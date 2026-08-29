local M = {}

---@class PickerGrepQuery
---@field pattern string
---@field globs string[]

---@class PickerGrepToken
---@field value string
---@field quoted boolean

-- Split a search query while preserving whether a token was quoted.
---@param query string
---@return PickerGrepToken[]
local function tokenize(query)
  local tokens = {}
  local value = {}
  local quote = nil
  local quoted = false
  local escaped = false

  -- Append the current token when it contains searchable text.
  local function push()
    if #value == 0 then
      return
    end
    tokens[#tokens + 1] = {
      value = table.concat(value),
      quoted = quoted,
    }
    value = {}
    quoted = false
  end

  for i = 1, #query do
    local char = query:sub(i, i)
    if escaped then
      value[#value + 1] = char
      escaped = false
    elseif char == "\\" then
      value[#value + 1] = char
      quoted = true
      escaped = true
    elseif quote then
      if char == quote then
        quote = nil
      else
        value[#value + 1] = char
      end
    elseif (char == '"' or char == "'") and #value == 0 then
      quote = char
      quoted = true
    elseif char:match("%s") then
      push()
    else
      value[#value + 1] = char
    end
  end

  push()
  return tokens
end

-- Return whether an unquoted token should be treated as a file glob.
---@param token PickerGrepToken
---@return boolean
local function is_glob(token)
  if token.quoted then
    return false
  end
  local value = token.value:gsub("^!", "")
  local has_glob = value:find("*", 1, true) ~= nil or value:find("?", 1, true) ~= nil or value:find("[", 1, true) ~= nil
  return value:match("^[*?]") ~= nil or (value:find("/", 1, true) ~= nil and has_glob)
end

-- Parse natural file globs from a live grep query.
---@param query string
---@return PickerGrepQuery
function M.parse(query)
  if query:match("%s+%-%-%s+") or query:match("%s+%-%-$") then
    return { pattern = query, globs = {} }
  end

  local patterns = {}
  local globs = {}
  for _, token in ipairs(tokenize(query)) do
    if is_glob(token) then
      globs[#globs + 1] = token.value
    else
      patterns[#patterns + 1] = token.value
    end
  end

  return {
    pattern = table.concat(patterns, " "),
    globs = globs,
  }
end

-- Merge query globs with any globs already configured for the picker.
---@param configured string|string[]|nil
---@param query_globs string[]
---@return string[]
local function merge_globs(configured, query_globs)
  local globs = {}
  if type(configured) == "string" then
    globs[1] = configured
  elseif type(configured) == "table" then
    vim.list_extend(globs, configured)
  end
  vim.list_extend(globs, query_globs)
  return globs
end

-- Run the Snacks grep finder with natural globs removed from the search pattern.
---@param opts snacks.picker.grep.Config
---@param ctx snacks.picker.finder.ctx
local function finder(opts, ctx)
  local query = M.parse(ctx.filter.search)
  local grep_opts = opts
  if #query.globs > 0 then
    grep_opts = vim.deepcopy(opts)
    grep_opts.glob = merge_globs(grep_opts.glob, query.globs)
  end

  local original_search = ctx.filter.search
  ctx.filter.search = query.pattern
  local ok, result = pcall(require("snacks.picker.source.grep").grep, grep_opts, ctx)
  ctx.filter.search = original_search
  if not ok then
    error(result, 0)
  end
  return result
end

-- Open workspace grep with natural trailing glob support.
---@param opts? snacks.picker.grep.Config
---@return snacks.Picker
function M.open(opts)
  opts = vim.tbl_deep_extend("force", opts or {}, { finder = finder })
  return require("snacks").picker.grep(opts)
end

return M

local M = {}

M.exact_names = {
  ".DS_Store",
}

M.regex_patterns = {}

local regex_cache = nil

-- Compile Vim regex patterns once for fast matching.
local function compiled_regexes()
  if regex_cache then
    return regex_cache
  end

  regex_cache = {}
  for _, pattern in ipairs(M.regex_patterns) do
    local ok, regex = pcall(vim.regex, pattern)
    if ok and regex then
      table.insert(regex_cache, regex)
    end
  end

  return regex_cache
end

-- Clear cached regexes after updating regex_patterns.
function M.reset_regex_cache()
  regex_cache = nil
end

-- Returns true when the name matches an exact entry or a regex pattern.
function M.is_ignored(name)
  for _, ignored in ipairs(M.exact_names) do
    if name == ignored then
      return true
    end
  end

  for _, regex in ipairs(compiled_regexes()) do
    if regex:match_str(name) then
      return true
    end
  end

  return false
end

-- Builds a fern-compatible regex from exact names and regex patterns.
function M.fern_exclude()
  local patterns = {}
  for _, name in ipairs(M.exact_names) do
    local escaped = vim.fn.escape(name, [[\.^$~[]*]])
    table.insert(patterns, "^" .. escaped .. "$")
  end

  for _, pattern in ipairs(M.regex_patterns) do
    table.insert(patterns, pattern)
  end

  return table.concat(patterns, "\\|")
end

return M

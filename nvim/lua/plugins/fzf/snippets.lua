local window = require("plugins.fzf.window")

local snippet_entries_cache = nil
local snippet_by_id_cache = nil

---Normalize values for consistent sorting.
local function sort_key(value)
  if type(value) == "string" then
    return value:lower()
  end
  return tostring(value or "")
end

---Return sorted category keys from a map.
local function sorted_categories(map)
  local keys = {}
  for key in pairs(map) do
    table.insert(keys, key)
  end
  table.sort(keys, function(a, b)
    return sort_key(a) < sort_key(b)
  end)
  return keys
end

---Return snippets sorted by trigger, then name.
local function sorted_snippets(snippet_list)
  local list = {}
  for index, snippet in ipairs(snippet_list) do
    list[index] = snippet
  end
  table.sort(list, function(a, b)
    local a_trigger = sort_key(a.trigger)
    local b_trigger = sort_key(b.trigger)
    if a_trigger == b_trigger then
      return sort_key(a.name) < sort_key(b.name)
    end
    return a_trigger < b_trigger
  end)
  return list
end

---Extract a snippet description string.
local function snippet_description(snippet)
  if type(snippet.description) == "table" then
    return snippet.description[1] or ""
  end
  if type(snippet.description) == "string" then
    return snippet.description
  end
  return ""
end

---Build and cache snippet entries to avoid repeated luasnip.available() calls.
local function build_snippet_cache()
  local luasnip = require("luasnip")
  local snippets = luasnip.available()
  local entries = {}
  local snippet_by_id = {}
  local entry_id = 0

  for _, category in ipairs(sorted_categories(snippets)) do
    local snippet_list = snippets[category]
    local real_snippets = snippet_list
    if type(luasnip.get_snippets) == "function" then
      real_snippets = luasnip.get_snippets(category) or {}
    end

    if type(real_snippets) == "table" then
      for _, snippet in ipairs(sorted_snippets(real_snippets)) do
        local description = snippet_description(snippet)
        entry_id = entry_id + 1
        snippet_by_id[entry_id] = snippet
        local entry =
          string.format("[%d] %s - %s (%s) : %s", entry_id, snippet.trigger, snippet.name or "", category, description)
        table.insert(entries, entry)
      end
    end
  end

  snippet_entries_cache = entries
  snippet_by_id_cache = snippet_by_id
end

local M = {}

-- Search available LuaSnip snippets via fzf-lua and insert the trigger
function M.search_snippets()
  window.run_in_edit_window(function()
    local fzf_lua = require("fzf-lua")
    local luasnip = require("luasnip")
    if not snippet_entries_cache or not snippet_by_id_cache then
      build_snippet_cache()
    end
    local entries = snippet_entries_cache or {}
    local snippet_by_id = snippet_by_id_cache or {}

    if #entries == 0 then
      vim.notify("No available snippets", vim.log.levels.INFO)
      return
    end

    fzf_lua.fzf_exec(entries, {
      prompt = "Select Snippet> ",
      actions = {
        ["default"] = function(selected)
          if not selected or not selected[1] then
            return
          end
          local id = tonumber(selected[1]:match("^%[(%d+)%]"))
          if not id then
            return
          end
          local snippet = snippet_by_id[id]
          if not snippet then
            return
          end
          vim.schedule(function()
            if type(snippet.copy) == "function" then
              vim.cmd("startinsert")
              luasnip.snip_expand(snippet)
            else
              vim.api.nvim_put({ snippet.trigger }, "c", true, true)
              vim.cmd("startinsert")
              luasnip.expand()
            end
          end)
        end,
      },
    })
  end)
end

return M

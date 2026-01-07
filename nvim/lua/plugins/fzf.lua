local utils = require("config.utils")
local fzf_actions = require("fzf-lua.actions")

local function toggle_visibility_actions()
  return {
    ["ctrl-u"] = { fzf_actions.toggle_hidden, { desc = "Toggle hidden" } },
    ["ctrl-o"] = { fzf_actions.toggle_ignore, { desc = "Toggle ignore" } },
  }
end

-- Make sure future edits happen in a non-Fern window, splitting if needed
local function ensure_edit_window()
  if vim.bo.filetype ~= "fern" then
    return
  end

  local current_win = vim.api.nvim_get_current_win()
  local windows = vim.api.nvim_tabpage_list_wins(0)

  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= "fern" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.api.nvim_set_current_win(current_win)
  vim.cmd("vsplit")
  vim.cmd("enew")
end

-- Run the given action after guaranteeing we are in an edit-friendly window
local function run_in_edit_window(action)
  ensure_edit_window()
  action()
end

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
        local entry = string.format(
          "[%d] %s - %s (%s) : %s",
          entry_id,
          snippet.trigger,
          snippet.name or "",
          category,
          description
        )
        table.insert(entries, entry)
      end
    end
  end

  snippet_entries_cache = entries
  snippet_by_id_cache = snippet_by_id
end

-- Search available LuaSnip snippets via fzf-lua and insert the trigger
local function search_snippets()
  run_in_edit_window(function()
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

if vim.g.vscode then
  utils.vscode_map("<leader>p", "workbench.action.quickOpen", "Quick Open (VSCode)")
  utils.vscode_map("<leader>g", "workbench.action.findInFiles", "Search in workspace (VSCode)")
  utils.vscode_map("<leader>f", "actions.find", "Search in file (VSCode)")
end

local M = {
  "ibhagwan/fzf-lua",

  lazy = true,
  cond = not vim.g.vscode,
  cmd = { "FzfLua" },

  keys = {
    {
      "sf",
      function()
        run_in_edit_window(function()
          require("fzf-lua").files({
            actions = toggle_visibility_actions(),
          })
        end)
      end,
      desc = "Search files in the current directory",
    },
    {
      "<leader>p",
      function()
        run_in_edit_window(function()
          require("fzf-lua").files({
            actions = toggle_visibility_actions(),
          })
        end)
      end,
      desc = "Search files in the current directory",
    },
    {
      "sF",
      function()
        run_in_edit_window(function()
          require("fzf-lua").oldfiles()
        end)
      end,
      desc = "Search old files",
    },
    {
      "sw",
      function()
        run_in_edit_window(function()
          require("fzf-lua").lines()
        end)
      end,
      desc = "Search word in the current file",
    },
    {
      "sW",
      function()
        run_in_edit_window(function()
          require("fzf-lua").live_grep({
            actions = toggle_visibility_actions(),
          })
        end)
      end,
      desc = "Search word in all files",
    },
    {
      "sb",
      function()
        run_in_edit_window(function()
          require("fzf-lua").buffers()
        end)
      end,
      desc = "Search buffers",
    },
    {
      "sB",
      function()
        run_in_edit_window(function()
          require("fzf-lua").blines()
        end)
      end,
      desc = "Search lines in open buffers",
    },
    {
      "sn", -- search snippets
      function()
        search_snippets()
      end,
      desc = "Search snippets",
    },
    {
      "ss",
      function()
        run_in_edit_window(function()
          require("fzf-lua").lsp_document_symbols()
        end)
      end,
      desc = "Symbols in current buffer (LSP)",
    },
    {
      "sS",
      function()
        run_in_edit_window(function()
          require("fzf-lua").lsp_workspace_symbols()
        end)
      end,
      desc = "Symbols in workspace (LSP)",
    },
    {
      "st",
      function()
        run_in_edit_window(function()
          require("fzf-lua").treesitter()
        end)
      end,
      desc = "Symbols in current buffer (Treesitter)",
    },
    {
      "sr",
      function()
        run_in_edit_window(function()
          require("fzf-lua").registers()
        end)
      end,
      desc = "Search registers",
    },
    {
      "sk",
      function()
        run_in_edit_window(function()
          require("fzf-lua").keymaps()
        end)
      end,
      desc = "Search keymaps",
    },
  },

  dependencies = {
    "DaikyXendo/nvim-material-icon",
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup({
          -- Avoid LSP-based root detection to prevent deprecated API usage
          detection_methods = { "pattern" },
          patterns = { ".git", "Makefile", "package.json" },
        })
      end,
    },
  },
}

M.config = function()
  vim.api.nvim_create_user_command("FzfLuaSnipAvailable", function()
    search_snippets()
  end, {})

  require("fzf-lua").setup({
    files = {
      find_opts = [[-type f]],
    },
    keymap = {
      fzf = {
        ["tab"] = "down",
        ["ctrl-j"] = "down",
        ["shift-tab"] = "up",
        ["ctrl-k"] = "up",
      },
    },
  })
end

return M

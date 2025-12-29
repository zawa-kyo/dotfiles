local utils = require("config.utils")

-- Make sure future edits happen in a non-Fern window, splitting if needed
local function ensure_edit_window()
  if vim.bo.filetype ~= "fern" then
    return
  end

  vim.cmd.wincmd("p")
  if vim.bo.filetype ~= "fern" then
    return
  end

  vim.cmd.wincmd("l")
  if vim.bo.filetype ~= "fern" then
    return
  end

  vim.cmd("vsplit")
  vim.cmd("enew")
  vim.cmd.wincmd("l")
end

-- Run the given action after guaranteeing we are in an edit-friendly window
local function run_in_edit_window(action)
  ensure_edit_window()
  action()
end

-- Search available LuaSnip snippets via fzf-lua and insert the trigger
local function search_snippets()
  run_in_edit_window(function()
    local luasnip = require("luasnip")
    local fzf_lua = require("fzf-lua")
    local snippets = luasnip.available()
    local entries = {}
    local snippet_by_id = {}
    local entry_id = 0

    for category, snippet_list in pairs(snippets) do
      local real_snippets = snippet_list
      if type(luasnip.get_snippets) == "function" then
        real_snippets = luasnip.get_snippets(category) or {}
      end

      if type(real_snippets) == "table" then
        for _, snippet in ipairs(real_snippets) do
          local description = ""
          if type(snippet.description) == "table" then
            description = snippet.description[1] or ""
          elseif type(snippet.description) == "string" then
            description = snippet.description
          end
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
          require("fzf-lua").files()
        end)
      end,
      desc = "Search files in the current directory",
    },
    {
      "<leader>p",
      function()
        run_in_edit_window(function()
          require("fzf-lua").files()
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
          require("fzf-lua").live_grep()
        end)
      end,
      desc = "Search word in all files",
    },
    {
      "_", -- <S-->
      function()
        search_snippets()
      end,
      desc = "Search snippets",
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

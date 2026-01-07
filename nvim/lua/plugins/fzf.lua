local utils = require("config.utils")
local fzf_actions = require("plugins.fzf.actions")
local fzf_snippets = require("plugins.fzf.snippets")
local fzf_window = require("plugins.fzf.window")

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
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.files({
            actions = fzf_actions.toggle_visibility_actions(),
          })
        end)
      end,
      desc = "Search files (cwd)",
    },
    {
      "<leader>p",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.files({
            actions = fzf_actions.toggle_visibility_actions(),
          })
        end)
      end,
      desc = "Search files (cwd)",
    },
    {
      "sF",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.oldfiles()
        end)
      end,
      desc = "Search old files",
    },
    {
      "sw",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.lines()
        end)
      end,
      desc = "Search in buffer",
    },
    {
      "sW",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.live_grep({
            actions = fzf_actions.toggle_visibility_actions(),
          })
        end)
      end,
      desc = "Search in workspace",
    },
    {
      "sb",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.buffers()
        end)
      end,
      desc = "Search buffers",
    },
    {
      "sB",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.blines()
        end)
      end,
      desc = "Search lines (buffers)",
    },
    {
      "sn", -- search snippets
      function()
        fzf_snippets.search_snippets()
      end,
      desc = "Search snippets",
    },
    {
      "ss",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.lsp_document_symbols()
        end)
      end,
      desc = "Search symbols (LSP buffer)",
    },
    {
      "sS",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.lsp_workspace_symbols()
        end)
      end,
      desc = "Search symbols (LSP workspace)",
    },
    {
      "st",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.treesitter()
        end)
      end,
      desc = "Search symbols (Treesitter buffer)",
    },
    {
      "sr",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.registers()
        end)
      end,
      desc = "Search registers",
    },
    {
      "sk",
      function()
        fzf_window.with_fzf(function(fzf_lua)
          fzf_lua.keymaps()
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
    fzf_snippets.search_snippets()
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

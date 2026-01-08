local snippets = require("plugins.picker.snippets")
local pickers = require("snacks").picker

local M = {}

M.keys = {
  {
    "<leader>p",
    function()
      pickers.files()
    end,
    desc = "Search files in workspace",
  },
  {
    "sf",
    function()
      pickers.files()
    end,
    desc = "Search files in workspace",
  },
  {
    "sF",
    function()
      pickers.recent()
    end,
    desc = "Search recent files",
  },
  {
    "sw",
    function()
      pickers.lines()
    end,
    desc = "Search lines in current buffer",
  },
  {
    "sW",
    function()
      pickers.grep()
    end,
    desc = "Search words in workspace",
  },
  {
    "sb",
    function()
      pickers.buffers()
    end,
    desc = "Search open buffers",
  },
  {
    "sB",
    function()
      pickers.grep({ buffers = true })
    end,
    desc = "Search words in open buffers",
  },
  {
    "sn", -- search snippets
    function()
      snippets.search_snippets()
    end,
    desc = "Search snippets",
  },
  {
    "ss",
    function()
      pickers.lsp_symbols()
    end,
    desc = "Search LSP symbols in current buffer",
  },
  {
    "sS",
    function()
      pickers.lsp_workspace_symbols()
    end,
    desc = "Search LSP symbols in workspace",
  },
  {
    "st",
    function()
      pickers.treesitter()
    end,
    desc = "Search Tree-sitter symbols in current buffer",
  },
  {
    "sr",
    function()
      pickers.registers()
    end,
    desc = "Search registers",
  },
  {
    "sR",
    function()
      pickers.resume()
    end,
    desc = "Resume previous picker",
  },
  {
    "sk",
    function()
      pickers.keymaps()
    end,
    desc = "Search keymaps",
  },
  {
    "sm",
    function()
      pickers.smart()
    end,
    desc = "Smart search for files and words",
  },
  {
    "sp",
    function()
      pickers.pickers()
    end,
    desc = "Search pickers",
  },
  {
    "sP",
    function()
      pickers.projects()
    end,
    desc = "Search projects",
  },
  {
    "sz",
    function()
      pickers.zoxide()
    end,
    desc = "Search zoxide directories",
  },
}

M.vscode = function()
  local utils = require("config.utils")

  utils.vscode_map("<leader>p", "workbench.action.quickOpen", "Quick Open (VSCode)")
  utils.vscode_map("<leader>g", "workbench.action.findInFiles", "Search in workspace (VSCode)")
  utils.vscode_map("<leader>f", "actions.find", "Search in file (VSCode)")
end

return M

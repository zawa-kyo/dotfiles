local M = {}

local snippets = require("plugins.picker.snippets")

local function picker()
  return require("snacks").picker
end

M.keys = {
  {
    "sb",
    function()
      picker().buffers()
    end,
    desc = "Search buffers",
  },
  {
    "sB",
    function()
      picker().grep({ buffers = true })
    end,
    desc = "Search words in open buffers",
  },
  {
    "sc",
    function()
      picker().colorschemes()
    end,
    desc = "Search colorschemes",
  },
  {
    "<leader>p",
    function()
      picker().files()
    end,
    desc = "Search files in workspace",
  },
  {
    "sf",
    function()
      picker().files()
    end,
    desc = "Search files in workspace",
  },
  {
    "sF",
    function()
      picker().recent()
    end,
    desc = "Search recent files",
  },
  {
    "sk",
    function()
      picker().keymaps()
    end,
    desc = "Search keymaps",
  },
  {
    "sm",
    function()
      picker().smart()
    end,
    desc = "Smart search for files and words",
  },
  {
    "sn", -- search snippets
    function()
      snippets.search_snippets()
    end,
    desc = "Search snippets",
  },
  {
    "sp",
    function()
      picker().pickers()
    end,
    desc = "Search pickers",
  },
  {
    "sP",
    function()
      picker().projects()
    end,
    desc = "Search projects",
  },
  {
    "sr",
    function()
      picker().registers()
    end,
    desc = "Search registers",
  },
  {
    "sR",
    function()
      picker().resume()
    end,
    desc = "Resume previous picker",
  },
  {
    "ss",
    function()
      picker().lsp_symbols()
    end,
    desc = "Search LSP symbols in current buffer",
  },
  {
    "sS",
    function()
      picker().lsp_workspace_symbols()
    end,
    desc = "Search LSP symbols in workspace",
  },
  {
    "st",
    function()
      picker().treesitter()
    end,
    desc = "Search Tree-sitter symbols in current buffer",
  },
  {
    "sw",
    function()
      picker().lines()
    end,
    desc = "Search lines in current buffer",
  },
  {
    "sW",
    function()
      picker().grep()
    end,
    desc = "Search words in workspace",
  },
  {
    "sz",
    function()
      picker().zoxide()
    end,
    desc = "Search directories via zoxide",
  },
}

M.vscode = function()
  local utils = require("config.utils")

  utils.vscode_map("<leader>p", "workbench.action.quickOpen", "Quick Open (VSCode)")
  utils.vscode_map("<leader>g", "workbench.action.findInFiles", "Search in workspace (VSCode)")
  utils.vscode_map("<leader>f", "actions.find", "Search in file (VSCode)")
end

return M

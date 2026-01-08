local snippets = require("plugins.picker.snippets")

local M = {}

M.keys = {
  {
    "<leader>p",
    function()
      require("snacks").picker.files()
    end,
    desc = "Search files in workspace",
  },
  {
    "sf",
    function()
      require("snacks").picker.files()
    end,
    desc = "Search files in workspace",
  },
  {
    "sF",
    function()
      require("snacks").picker.recent()
    end,
    desc = "Search recent files",
  },
  {
    "sw",
    function()
      require("snacks").picker.lines()
    end,
    desc = "Search lines in current buffer",
  },
  {
    "sW",
    function()
      require("snacks").picker.grep()
    end,
    desc = "Search words in workspace",
  },
  {
    "sb",
    function()
      require("snacks").picker.buffers()
    end,
    desc = "Search open buffers",
  },
  {
    "sB",
    function()
      require("snacks").picker.grep({ buffers = true })
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
      require("snacks").picker.lsp_symbols()
    end,
    desc = "Search LSP symbols in current buffer",
  },
  {
    "sS",
    function()
      require("snacks").picker.lsp_workspace_symbols()
    end,
    desc = "Search LSP symbols in workspace",
  },
  {
    "st",
    function()
      require("snacks").picker.treesitter()
    end,
    desc = "Search Tree-sitter symbols in current buffer",
  },
  {
    "sr",
    function()
      require("snacks").picker.registers()
    end,
    desc = "Search registers",
  },
  {
    "sR",
    function()
      require("snacks").picker.resume()
    end,
    desc = "Resume previous picker",
  },
  {
    "sk",
    function()
      require("snacks").picker.keymaps()
    end,
    desc = "Search keymaps",
  },
  {
    "sm",
    function()
      require("snacks").picker.smart()
    end,
    desc = "Smart search for files and words",
  },
  {
    "sp",
    function()
      require("snacks").picker.pickers()
    end,
    desc = "Search pickers",
  },
  {
    "sP",
    function()
      require("snacks").picker.projects()
    end,
    desc = "Search projects",
  },
  {
    "sz",
    function()
      require("snacks").picker.zoxide()
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

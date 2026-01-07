local actions = require("plugins.fzf.actions")
local snippets = require("plugins.fzf.snippets")
local window = require("plugins.fzf.window")

local M = {}

M.keys = {
  {
    "sf",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.files({
          actions = actions.toggle_visibility_actions(),
        })
      end)
    end,
    desc = "Search files (cwd)",
  },
  {
    "<leader>p",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.files({
          actions = actions.toggle_visibility_actions(),
        })
      end)
    end,
    desc = "Search files (cwd)",
  },
  {
    "sF",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.oldfiles()
      end)
    end,
    desc = "Search old files",
  },
  {
    "sw",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.lines()
      end)
    end,
    desc = "Search in buffer",
  },
  {
    "sW",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.live_grep({
          actions = actions.toggle_visibility_actions(),
        })
      end)
    end,
    desc = "Search in workspace",
  },
  {
    "sb",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.buffers()
      end)
    end,
    desc = "Search buffers",
  },
  {
    "sB",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.blines()
      end)
    end,
    desc = "Search lines (buffers)",
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
      window.with_fzf(function(fzf_lua)
        fzf_lua.lsp_document_symbols()
      end)
    end,
    desc = "Search symbols (LSP buffer)",
  },
  {
    "sS",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.lsp_workspace_symbols()
      end)
    end,
    desc = "Search symbols (LSP workspace)",
  },
  {
    "st",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.treesitter()
      end)
    end,
    desc = "Search symbols (Treesitter buffer)",
  },
  {
    "sr",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.registers()
      end)
    end,
    desc = "Search registers",
  },
  {
    "sk",
    function()
      window.with_fzf(function(fzf_lua)
        fzf_lua.keymaps()
      end)
    end,
    desc = "Search keymaps",
  },
}

M.vscode = function()
  local utils = require("config.utils")

  utils.vscode_map("<leader>p", "workbench.action.quickOpen", "Quick Open (VSCode)")
  utils.vscode_map("<leader>g", "workbench.action.findInFiles", "Search in workspace (VSCode)")
  utils.vscode_map("<leader>f", "actions.find", "Search in file (VSCode)")
end

return M

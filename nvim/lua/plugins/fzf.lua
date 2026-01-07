local fzf_keymaps = require("plugins.fzf.keymaps")
local fzf_snippets = require("plugins.fzf.snippets")

if vim.g.vscode then
  fzf_keymaps.vscode()
end

local M = {
  "ibhagwan/fzf-lua",

  lazy = true,
  cond = not vim.g.vscode,
  cmd = { "FzfLua" },

  keys = fzf_keymaps.keys,

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

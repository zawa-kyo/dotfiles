return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,

  opts = {
    explorer = {
      replace_netrw = false,
      trash = true,
    },
    lazygit = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    picker = require("plugins.picker.config"),
    terminal = {
      win = {
        style = "terminal",
        position = "float",
        backdrop = 60,
        height = 0.9,
        width = 0.9,
      },
    },
  },

  config = function(_, opts)
    local Snacks = require("snacks")
    Snacks.setup(opts)
    vim.notify = Snacks.notifier
  end,
}

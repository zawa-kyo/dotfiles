return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,

  opts = {
    notifier = {
      enabled = true,
    },
  },

  config = function(_, opts)
    local Snacks = require("snacks")
    Snacks.setup(opts)
    vim.notify = Snacks.notifier
  end,
}

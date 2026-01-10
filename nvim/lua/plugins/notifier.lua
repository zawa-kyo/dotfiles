return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts = {
    notifier = {
      enabled = true,
    },
  },

  config = function()
    vim.notify = require("snacks").notifier
  end,
}

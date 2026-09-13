return {
  "akinsho/bufferline.nvim",

  cond = not vim.g.vscode,
  dependencies = "DaikyXendo/nvim-material-icon",
  event = "UIEnter",

  keys = {
    {
      "tB",
      function()
        vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
      end,
      desc = "Toggle tab line",
    },
  },

  opts = {
    options = {
      mode = "tabs",
    },
  },
}

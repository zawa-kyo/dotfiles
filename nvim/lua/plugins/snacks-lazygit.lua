return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  event = "VeryLazy",

  keys = {
    {
      "Xg",
      function()
        require("snacks").lazygit()
      end,
      desc = "Run lazygit",
    },
    {
      "Xl",
      function()
        require("snacks").lazygit.log()
      end,
      desc = "Run lazygit with the log view",
    },
    {
      "XL",
      function()
        require("snacks").lazygit.log_file()
      end,
      desc = "Run lazygit with the log of the current file",
    },
  },

  opts = {
    lazygit = {
      enabled = true,
    },
  },
}

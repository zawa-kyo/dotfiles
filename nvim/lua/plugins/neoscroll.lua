local M = {
  "karb94/neoscroll.nvim",

  lazy = false,
  cond = not vim.g.vscode,

  keys = {
    {
      "<C-u>",
      function()
        require("neoscroll").ctrl_u({ duration = 250 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll up",
    },
    {
      "<C-d>",
      function()
        require("neoscroll").ctrl_d({ duration = 250 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll down",
    },
    {
      "<C-b>",
      function()
        require("neoscroll").ctrl_b({ duration = 550 })
      end,
      mode = { "n", "v", "x" },
      desc = "Page up",
    },
    {
      "<C-f>",
      function()
        require("neoscroll").ctrl_f({ duration = 550 })
      end,
      mode = { "n", "v", "x" },
      desc = "Page down",
    },
    {
      "<Tab>",
      function()
        require("neoscroll").ctrl_d({ duration = 550 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll down",
    },
    {
      "<S-Tab>",
      function()
        require("neoscroll").ctrl_u({ duration = 550 })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll up",
    },
  },

  config = function()
    require("neoscroll").setup({ easing = "sine" })
  end,
}

return M

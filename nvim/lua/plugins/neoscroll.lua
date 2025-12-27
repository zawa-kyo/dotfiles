local duration = {
  scroll = 250,
  page = 550,
}

local M = {
  "karb94/neoscroll.nvim",

  lazy = false,
  cond = not vim.g.vscode,

  keys = {
    {
      "<C-u>",
      function()
        require("neoscroll").ctrl_u({ duration = duration.scroll })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll up",
    },
    {
      "<C-d>",
      function()
        require("neoscroll").ctrl_d({ duration = duration.scroll })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll down",
    },
    {
      "<C-b>",
      function()
        require("neoscroll").ctrl_b({ duration = duration.page })
      end,
      mode = { "n", "v", "x" },
      desc = "Page up",
    },
    {
      "<C-f>",
      function()
        require("neoscroll").ctrl_f({ duration = duration.page })
      end,
      mode = { "n", "v", "x" },
      desc = "Page down",
    },
    {
      "<Tab>",
      function()
        require("neoscroll").ctrl_d({ duration = duration.page })
      end,
      mode = { "n", "v", "x" },
      desc = "Scroll down",
    },
    {
      "<S-Tab>",
      function()
        require("neoscroll").ctrl_u({ duration = duration.page })
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

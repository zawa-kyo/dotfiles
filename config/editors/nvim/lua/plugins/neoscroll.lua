local duration = {
  scroll = 250,
  page = 550,
}

local modes = { "n", "v", "x" }

local M = {
  "karb94/neoscroll.nvim",

  cond = not vim.g.vscode,

  keys = {
    {
      "<C-u>",
      function()
        require("neoscroll").ctrl_u({ duration = duration.scroll })
      end,
      mode = modes,
      desc = "Scroll up",
    },
    {
      "<C-d>",
      function()
        require("neoscroll").ctrl_d({ duration = duration.scroll })
      end,
      mode = modes,
      desc = "Scroll down",
    },
    {
      "<C-b>",
      function()
        require("neoscroll").ctrl_b({ duration = duration.page })
      end,
      mode = modes,
      desc = "Page up",
    },
    {
      "<C-f>",
      function()
        require("neoscroll").ctrl_f({ duration = duration.page })
      end,
      mode = modes,
      desc = "Page down",
    },
    {
      "<Tab>",
      function()
        require("neoscroll").ctrl_d({ duration = duration.page })
      end,
      mode = modes,
      desc = "Scroll down",
    },
    {
      "<S-Tab>",
      function()
        require("neoscroll").ctrl_u({ duration = duration.page })
      end,
      mode = modes,
      desc = "Scroll up",
    },
    {
      "zj",
      function()
        require("neoscroll").zt({ half_win_duration = duration.scroll })
      end,
      mode = modes,
      desc = "Scroll top",
    },
    {
      "zz",
      function()
        require("neoscroll").zz({ half_win_duration = duration.scroll })
      end,
      mode = modes,
      desc = "Scroll center",
    },
    {
      "zk",
      function()
        require("neoscroll").zb({ half_win_duration = duration.scroll })
      end,
      mode = modes,
      desc = "Scroll bottom",
    },
  },

  config = function()
    require("neoscroll").setup({ easing = "sine" })
  end,
}

return M

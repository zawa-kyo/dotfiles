return {
  "ruifm/gitlinker.nvim",

  cond = not vim.g.vscode,
  event = { "BufRead", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    {
      "rgL",
      function()
        require("gitlinker").get_buf_range_url("n", {
          action_callback = require("gitlinker.actions").open_in_browser,
        })
      end,
      desc = "Open git link in browser",
    },
    {
      "<leader>yl",
      function()
        require("gitlinker").get_buf_range_url("v")
      end,
      mode = "v",
      desc = "Copy git link",
    },
    {
      "rgl",
      function()
        require("gitlinker").get_buf_range_url("v", {
          action_callback = require("gitlinker.actions").open_in_browser,
        })
      end,
      mode = "v",
      desc = "Open git link in browser",
    },
    {
      "<leader>yl",
      function()
        require("gitlinker").get_buf_range_url("n")
      end,
      desc = "Copy git link",
    },
  },

  config = function()
    require("gitlinker").setup()
  end,
}

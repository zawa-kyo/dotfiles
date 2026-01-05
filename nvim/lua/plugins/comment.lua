return {
  "numToStr/Comment.nvim",

  cond = not vim.g.vscode,
  lazy = true,
  event = {
    "BufRead",
    "BufNewFile",
  },

  keys = {
    {
      "<leader>/",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      desc = "Toggle comment",
    },
    {
      "<leader>/",
      function()
        local api = require("Comment.api")
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end,
      mode = "x",
      desc = "Toggle comment",
    },
  },
  config = function()
    require("Comment").setup()
  end,
}

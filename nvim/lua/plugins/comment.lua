return {
  "numToStr/Comment.nvim",


  keys = {
    {
      "tc", -- toggle comments
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      desc = "Toggle comment",
    },
    {
      "<leader>/",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      desc = "Toggle comment",
    },
    {
      "tc", -- toggle comments
      function()
        local api = require("Comment.api")
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end,
      mode = "x",
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
    require("Comment").setup({
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` etc.
        basic = false,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = false,
      },
    })

    -- Remove default comment keymaps from Neovim runtime
    pcall(vim.keymap.del, "n", "gcc")
  end,
}

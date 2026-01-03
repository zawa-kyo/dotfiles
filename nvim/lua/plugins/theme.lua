return {
  {
    "gbprod/nord.nvim",

    lazy = true,
    event = "VimEnter",
    priority = 1000,

    config = function()
      require("nord").setup({
        transparent = true,
      })

      vim.cmd.colorscheme("nord")
    end,
  },
}

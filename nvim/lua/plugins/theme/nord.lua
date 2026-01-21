return {
  "gbprod/nord.nvim",

  lazy = true,

  config = function()
    require("nord").setup({
      transparent = true,
    })
  end,
}

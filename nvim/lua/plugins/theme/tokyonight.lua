return {
  "folke/tokyonight.nvim",

  lazy = true,

  config = function()
    require("tokyonight").setup({
      transparent = true,
    })
  end,
}

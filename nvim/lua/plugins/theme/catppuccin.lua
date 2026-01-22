return {
  "catppuccin/nvim",
  name = "catppuccin",

  lazy = true,

  config = function()
    require("catppuccin").setup({
      transparent_background = true,
    })
  end,
}

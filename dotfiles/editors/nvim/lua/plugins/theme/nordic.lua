return {
  "AlexvZyl/nordic.nvim",

  lazy = true,

  config = function()
    require("nordic").setup({
      transparent = {
        bg = true,
        float = true,
      },
    })
  end,
}

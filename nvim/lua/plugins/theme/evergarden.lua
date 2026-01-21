return {
  "comfysage/evergarden",

  lazy = true,

  config = function()
    require("evergarden").setup({
      transparent_background = true,
    })
  end,
}

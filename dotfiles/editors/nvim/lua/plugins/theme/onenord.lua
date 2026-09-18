return {
  "rmehri01/onenord.nvim",

  lazy = true,

  config = function()
    require("onenord").setup({
      disable = {
        background = true,
        float_background = true,
      },
    })
  end,
}

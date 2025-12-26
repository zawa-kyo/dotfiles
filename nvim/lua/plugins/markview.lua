return {
  "OXY2DEV/markview.nvim",
  lazy = false,

  config = function()
    local presets = require("markview.presets").headings
    require("markview").setup({
      markdown = {
        headings = presets.glow,
      },
    })
  end,
}

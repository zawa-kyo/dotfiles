return {
  "OXY2DEV/markview.nvim",

  lazy = false,
  cond = not vim.g.vscode,

  config = function()
    local presets = require("markview.presets").headings

    require("markview").setup({
      markdown = {
        headings = presets.glow,
        horizontal_rules = presets.thin,
        tables = presets.rounded,
      },

      preview = {
        enable = true,
        enable_hybrid_mode = true,
        modes = { "n", "i" },
        hybrid_modes = { "n", "i" },
        linewise_hybrid_mode = true,
        edit_range = { 0, 0 },
      },
    })
  end,
}

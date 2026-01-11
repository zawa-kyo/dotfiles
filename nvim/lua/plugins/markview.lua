-- TODO: Consider migrating to render-markdown.nvim.
return {
  "OXY2DEV/markview.nvim",

  lazy = true,
  cond = not vim.g.vscode,
  ft = { "markdown" },
  cmd = { "Markview" },
  keys = {
    { "tm", ":Markview toggle<CR>", desc = "Toggle Markdown rendering" },
  },

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

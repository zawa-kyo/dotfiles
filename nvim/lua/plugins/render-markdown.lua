return {
  "MeanderingProgrammer/render-markdown.nvim",

  lazy = true,
  ft = { "markdown" },
  cond = not vim.g.vscode,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "DaikyXendo/nvim-material-icon",
  },

  config = function()
    require("render-markdown").setup({
      render_modes = true,
      heading = { position = 'inline' },
    })
  end,

  keys = {
    { "<Leader>tm", ":RenderMarkdown toggle<CR>", desc = "Toggle Markdown rendering" },
  },
}

return {
  "MeanderingProgrammer/render-markdown.nvim",

  lazy = true,
  ft = { "markdown" },
  cond = not vim.g.vscode,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    require("render-markdown").setup({
      render_modes = true,
    })
  end,

  keys = {
    { "<Leader>tm", ":RenderMarkdown toggle<CR>", desc = "Toggle Markdown rendering" },
  },
}

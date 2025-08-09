return {
  "MeanderingProgrammer/render-markdown.nvim",

  lazy = true,
  ft = { "markdown" },
  cond = not vim.g.vscode,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}

return {
  "nvim-treesitter/nvim-treesitter",

  lazy = true,
  event = {
    "BufNewFile",
    "BufRead",
  },

  -- Load in vscode to enable textobjects
  -- cond = not vim.g.vscode,

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "markdown",
        "markdown_inline",
        "python",
        "java",
        "dart",
        "rust",
      },
      highlight = {
        enable = true,
      },
    })
  end,
}

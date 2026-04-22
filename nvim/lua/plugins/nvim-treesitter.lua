return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",

  event = {
    "BufNewFile",
    "BufRead",
  },

  -- Load in vscode to enable textobjects
  -- cond = not vim.g.vscode,

  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    "nvim-treesitter/nvim-treesitter-context",
  },
  build = ":TSUpdate",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- nvim-treesitter main does not support lazy-loading.
  lazy = false,

  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    "nvim-treesitter/nvim-treesitter-context",
  },
  build = ":TSUpdate",
  opts = {
    install_dir = vim.fn.stdpath("data") .. "/site",
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
  end,
}

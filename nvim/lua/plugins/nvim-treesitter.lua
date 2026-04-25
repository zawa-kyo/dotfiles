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

    -- Prefer Neovim's bundled vim parser until nvim-treesitter ships a compatible one.
    for _, path in ipairs(vim.api.nvim_get_runtime_file("parser/vim.so", true)) do
      if path:match("/lib/nvim/parser/") then
        vim.treesitter.language.add("vim", { path = path })
        break
      end
    end
  end,
}

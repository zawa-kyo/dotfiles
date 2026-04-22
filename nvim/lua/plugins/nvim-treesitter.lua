return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",

  event = {
    "BufNewFile",
    "BufRead",
  },

  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    "nvim-treesitter/nvim-treesitter-context",
  },
  build = ":TSUpdate",
  config = function()
    -- Prefer Neovim's bundled vim parser until nvim-treesitter ships a compatible one.
    for _, path in ipairs(vim.api.nvim_get_runtime_file("parser/vim.so", true)) do
      if path:match("/lib/nvim/parser/") then
        vim.treesitter.language.add("vim", { path = path })
        break
      end
    end
  end,
}

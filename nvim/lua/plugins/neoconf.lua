return {
  "folke/neoconf.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("neoconf").setup()
  end,
}

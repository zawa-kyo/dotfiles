-- flutter-tools delegates LSP (dartls) setup; reuse common on_attach/capabilities
return {
  "nvim-flutter/flutter-tools.nvim",

  lazy = true,
  ft = { "dart" },
  cond = not vim.g.vscode,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },

  config = function()
    local common = require("config.lsp")
    require("flutter-tools").setup({
      lsp = {
        on_attach = common.on_attach,
        capabilities = common.capabilities,
      },
    })
  end,
}

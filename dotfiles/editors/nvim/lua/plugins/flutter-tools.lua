-- flutter-tools delegates LSP (dartls) setup; reuse common on_attach/capabilities
return {
  "nvim-flutter/flutter-tools.nvim",

  ft = { "dart" },
  cond = not vim.g.vscode,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },

  config = function()
    local common = require("config.lsp")
    require("flutter-tools").setup({
      widget_guides = {
        enabled = true,
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      dev_log = {
        enabled = true,
        filter = nil,
        notify_errors = true,
      },
      dev_tools = {
        autostart = true,
        auto_open_browser = false,
      },
      lsp = {
        on_attach = common.on_attach,
        capabilities = common.capabilities,
      },
    })
  end,
}

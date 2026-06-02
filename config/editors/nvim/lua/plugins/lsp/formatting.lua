-- Formatter integration via mason-null-ls + null-ls
return {
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufRead", "BufNewFile" },
    cond = not vim.g.vscode,
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local mason_null_ls = require("mason-null-ls")
      mason_null_ls.setup({
        ensure_installed = {
          "prettierd",
        },
        automatic_installation = false,
      })

      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local common = require("config.lsp")

      null_ls.setup({
        sources = {
          -- Use Prettier daemon to match VS Code's prettier-vscode experience
          formatting.prettierd.with({
            filetypes = { "markdown", "mdx" },
          }),
        },
        on_attach = common.on_attach,
      })
    end,
  },
}

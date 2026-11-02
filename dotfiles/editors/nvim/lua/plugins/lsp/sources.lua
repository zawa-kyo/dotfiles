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
      require("mason-null-ls").setup({
        ensure_installed = { "prettierd" },
        automatic_installation = false,
      })

      local sources = require("plugins.lsp.formatter")()
      vim.list_extend(sources, require("plugins.lsp.linter")())
      require("null-ls").setup({
        sources = sources,
        on_attach = require("config.lsp").on_attach,
      })
    end,
  },
}

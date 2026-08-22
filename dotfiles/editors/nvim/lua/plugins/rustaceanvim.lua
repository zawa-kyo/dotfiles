return {
  "mrcjkb/rustaceanvim",

  version = "^9",
  lazy = false,
  cond = not vim.g.vscode,
  init = function()
    -- Reuse the shared LSP behavior while rustaceanvim owns rust-analyzer.
    vim.g.rustaceanvim = function()
      local common = require("config.lsp")
      return {
        tools = {
          -- Load Neotest after rust-analyzer can discover Rust tests.
          on_initialized = function()
            require("lazy").load({ plugins = { "neotest" } })
          end,
        },
        server = {
          auto_attach = vim.fn.executable(vim.env.RUSTC or "rustc") == 1 and vim.fn.executable("cargo") == 1,
          capabilities = common.capabilities,
          on_attach = common.on_attach,
        },
      }
    end
  end,
}

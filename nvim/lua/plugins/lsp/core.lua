-- Core LSP tooling: Neoconf, Mason, and mason-lspconfig wiring
local servers = {
  "lua_ls", -- Lua
  "ts_ls", -- TypeScript
  "pyright", -- Python
  "taplo", -- TOML
  "rust_analyzer", -- Rust
}

return {
  {
    "folke/neoconf.nvim",
    lazy = false,
    priority = 1000, -- Ensure configuration data loads before servers
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("neoconf").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
    },
    cond = not vim.g.vscode,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    cond = not vim.g.vscode,
    dependencies = {
      "neovim/nvim-lspconfig",
      "onsails/lspkind-nvim",
      "hrsh7th/vim-vsnip",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "williamboman/mason.nvim",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = servers,
        -- Keep a single startup path via vim.lsp.config handlers
        automatic_enable = false,
      })

      local function setup_server(server)
        local common = require("config.lsp")
        vim.lsp.config(
          server,
          vim.tbl_deep_extend("force", vim.lsp.config[server] or {}, {
            capabilities = common.capabilities,
            on_attach = common.on_attach,
          })
        )
        vim.lsp.enable(server)
      end

      if type(mason_lspconfig.setup_handlers) == "function" then
        mason_lspconfig.setup_handlers({
          function(server)
            setup_server(server)
          end,
        })
      else
        for _, server in ipairs(servers) do
          setup_server(server)
        end
      end

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
      })
    end,
  },
}

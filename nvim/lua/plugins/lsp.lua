-- LSP setup strategy
-- - Using lspconfig-led approach (common practice with customization).
-- - mason manages installs; we disable mason-lspconfig automatic_enable to avoid
--   duplicate startup paths. If you switch to mason-led, remove lspconfig.setup
--   calls and set automatic_enable = true.
local M = {}

-- LSP servers to install
M.servers = {
  "lua_ls", -- Lua
  "ts_ls", -- TypeScript
  "pyright", -- Python
  "taplo", -- TOML
}

-- Neoconf (should run before LSP configuration)
table.insert(M, {
  "folke/neoconf.nvim",

  lazy = false,
  priority = 1000, -- Ensure this loads first

  dependencies = {
    "neovim/nvim-lspconfig",
  },

  config = function()
    require("neoconf").setup()
  end,
})

-- Mason: LSP package manager
table.insert(M, {
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
})

table.insert(M, {
  "zbirenbaum/copilot.lua",

  lazy = true,
  event = "InsertEnter",
  cond = not vim.g.vscode,

  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-a>",
          accept_word = false,
          accept_line = false,
        },
      },
      panel = { enabled = false },
    })
  end,
})

table.insert(M, {
  "zbirenbaum/copilot-cmp",

  lazy = true,
  event = "InsertEnter",
  cond = not vim.g.vscode,

  dependencies = {
    "zbirenbaum/copilot.lua",
  },

  config = function()
    require("copilot_cmp").setup()
  end,
})

-- mason-lspconfig: Automatically sets up language servers installed via Mason
table.insert(M, {
  "williamboman/mason-lspconfig.nvim",

  lazy = true,
  event = {
    "BufReadPre",
    "BufNewFile",
  },
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
      ensure_installed = M.servers,
      -- Do not auto-enable via vim.lsp.enable(); lspconfig handles startup.
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

    -- Single startup path: configure each server via lspconfig handlers.
    if type(mason_lspconfig.setup_handlers) == "function" then
      mason_lspconfig.setup_handlers({
        function(server)
          setup_server(server)
        end,
      })
    else
      -- Fallback for environments where setup_handlers is unavailable
      for _, server in ipairs(M.servers) do
        setup_server(server)
      end
    end

    -- Diagnostic settings
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
    })
  end,
})

-- nvim-cmp: Completion settings with modern theme
table.insert(M, {
  "hrsh7th/nvim-cmp",

  lazy = true,
  event = "InsertEnter",
  cond = not vim.g.vscode,

  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- LSP completion source
    "hrsh7th/cmp-buffer", -- Buffer completion source
    "hrsh7th/cmp-path", -- Path completion source
    "hrsh7th/cmp-cmdline", -- Command-line completion source
    "zbirenbaum/copilot-cmp", -- Copilot completion source
  },

  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      local text = vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
      return col ~= 0 and text:match("^%s*$") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "copilot" },
        { name = "nvim_lsp_signature_help" },
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      experimental = {
        ghost_text = false,
      },

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol",
          preset = "codicons",
          maxwidth = 50,
          symbol_map = { Copilot = "" },
        }),
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "path" },
        { name = "cmdline" },
        { name = "nvim_lsp_document_symbol" },
      },
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        {
          name = "buffer",
          option = {
            -- Only consider continuous keyword characters
            keyword_pattern = [[\k\+]],
          },
        },
        { name = "nvim_lsp_document_symbol" },
      },
    })
  end,
})

-- mason-null-ls
table.insert(M, {
  "jay-babu/mason-null-ls.nvim",

  lazy = true,
  event = {
    "BufRead",
    "BufNewFile",
  },
  cond = not vim.g.vscode,

  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
})

return M

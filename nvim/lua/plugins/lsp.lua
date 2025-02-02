local M = {}

-- LSP servers to install
M.servers = {
    "lua_ls",  -- Lua
    "ts_ls",   -- TypeScript
    "pyright", -- Python
}

-- Neoconf (should run before LSP configuration)
table.insert(M, {
    "folke/neoconf.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    priority = 1000, -- Ensure this loads first
    config = function()
        require("neoconf").setup()
    end,
})

-- Mason: LSP package manager
table.insert(M, {
    "williamboman/mason.nvim",
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
            },
        })
    end,
})

-- mason-lspconfig: Automatically sets up language servers installed via Mason
table.insert(M, {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "onsails/lspkind-nvim",
        "hrsh7th/vim-vsnip",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    config = function()
        require("mason-lspconfig").setup {
            ensure_installed = M.servers
        }
        require("mason-lspconfig").setup_handlers({
            function(server)
                local opt = {
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                }
                require("lspconfig")[server].setup(opt)
            end
        })

        -- Diagnostic settings
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
        )

        -- Reference highlight
        vim.cmd [[
            set updatetime=500
            highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#F1943B guibg=#374152
            highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#F1943B guibg=#374152
            highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#F1943B guibg=#374152
            augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end,
})

-- nvim-cmp: Completion settings with modern theme
table.insert(M, {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- LSP completion source
        "hrsh7th/cmp-buffer",   -- Buffer completion source
        "hrsh7th/cmp-path",     -- Path completion source
        "hrsh7th/cmp-cmdline",  -- Command-line completion source
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")


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
                { name = "nvim_lsp_signature_help" }
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.select_next_item(),
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
                }),
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = ({
                { name = "path" },
                { name = "cmdline" },
                { name = "nvim_lsp_document_symbol" },
            }),
        })

        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = ({
                { name = "buffer" },
                { name = "nvim_lsp_document_symbol" },
            }),
        })
    end,
})

-- mason-null-ls
table.insert(M, {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        'williamboman/mason.nvim',
        'nvimtools/none-ls.nvim',
    },
})

return M

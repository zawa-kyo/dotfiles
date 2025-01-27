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
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/vim-vsnip",
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
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/vim-vsnip",
    },
    config = function()
        local cmp = require("cmp")

        -- Define icons similar to coc.nvim
        local kind_icons = {
            Text = "",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "",
            File = "󰈙",
            Reference = "",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰗴",
        }

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
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                ["<C-l>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            experimental = {
                ghost_text = false,
            },
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

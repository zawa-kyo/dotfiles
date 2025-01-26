-- TODO: Refactor LSP setup into 'lsp' directory
return {
    -- Neoconf setup (should run before LSP configuration)
    {
        "folke/neoconf.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        priority = 1000, -- Ensure this loads first
        config = function()
            require("neoconf").setup()
        end,
    },

    -- Mason and LSP-related plugins
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                },
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/vim-vsnip",
        },
        config = function()
            require("mason-lspconfig").setup_handlers({
                function(server)
                    local opt = {
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    }
                    require("lspconfig")[server].setup(opt)
                end
            })

            -- Hover with ESC to close
            local function hover()
                vim.lsp.buf.hover()
                local current_buf = vim.api.nvim_get_current_buf()

                -- Autocmd to close the hover window when ESC is pressed
                vim.api.nvim_create_autocmd("BufLeave", {
                    buffer = current_buf,
                    once = true,
                    callback = function()
                        -- Close floating window if it exists
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            if vim.api.nvim_win_get_config(win).relative ~= "" then
                                vim.api.nvim_win_close(win, true)
                            end
                        end
                    end,
                })
            end

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
    },

    -- Completion settings with modern theme
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/vim-vsnip" },
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
                    ghost_text = false, -- Disable ghost text for simplicity
                },
            })
        end,
    },
}

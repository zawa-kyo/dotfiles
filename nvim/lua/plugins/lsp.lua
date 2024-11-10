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

            -- Show hover information for symbol under cursor
            vim.keymap.set("n", "K", hover)

            -- Format the current buffer
            vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>")

            -- Show references for the symbol under cursor
            vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")

            -- Go to the definition of the symbol under cursor
            vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")

            -- Go to the declaration of the symbol under cursor
            vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")

            -- Go to the implementation of the symbol under cursor
            vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")

            -- Go to the type definition of the symbol under cursor
            vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")

            -- Rename the symbol under cursor
            vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")

            -- Show code actions for the current line or selection
            vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")

            -- Show diagnostics in a floating window
            vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")

            -- Go to the next diagnostic
            vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")

            -- Go to the previous diagnostic
            vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

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

    -- Completion settings
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/vim-vsnip" },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    -- { name = "buffer" },
                    -- { name = "path" },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-l>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                }),
                experimental = {
                    ghost_text = true,
                },
            })
        end,
    },
}

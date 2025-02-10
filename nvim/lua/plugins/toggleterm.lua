return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cnd = not vim.g.vscode,
        config = function()
            require("toggleterm").setup {
                size = 20,
                open_mapping = [[\]],
                direction = 'float',
            }

            -- Disable mouse when entering terminal mode
            vim.api.nvim_create_autocmd("TermEnter", {
                pattern = "*",
                callback = function()
                    vim.opt.mouse = ""
                end,
            })

            -- Re-enable mouse when leaving terminal mode
            vim.api.nvim_create_autocmd("TermLeave", {
                pattern = "*",
                callback = function()
                    vim.opt.mouse = "a"
                end,
            })
        end,
    }
}

return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("fzf-lua").setup({
            files = {
                -- Changed to POSIX-compliant options for 'find'
                find_opts = [[-type f]]
            },
            keymap = {
                fzf = {
                    ["tab"] = "down",
                    ["ctrl-j"] = "down",
                    ["shift-tab"] = "up",
                    ["ctrl-k"] = "up",
                },
            }
        })

        local opts = { noremap = true, silent = true }

        -- File name search
        vim.api.nvim_set_keymap("n", "<leader>p", ":FzfLua files<CR>", opts)
        -- Search within all file
        vim.api.nvim_set_keymap("n", "<leader>g", ":FzfLua live_grep<CR>", opts)
        -- Search within the current file
        vim.api.nvim_set_keymap("n", "<leader>f", ":FzfLua lines<CR>", opts)
    end
}

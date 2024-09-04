return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("fzf-lua").setup({
            files = {
                -- POSIX準拠のfind用オプションに変更
                find_opts = [[-type f]]
            }
        })

        local opts = { noremap = true, silent = true }

        -- ファイル検索
        vim.api.nvim_set_keymap("n", "<leader>f", ":FzfLua files<CR>", opts)
        -- 全体検索
        vim.api.nvim_set_keymap("n", "<leader>g", ":FzfLua live_grep<CR>", opts)
    end
}

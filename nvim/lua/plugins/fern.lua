return {
    "lambdalisue/fern.vim",
    config = function()
        -- leader
        vim.g.mapleader = " "

        -- options for key mappings
        local opts = { noremap = true, silent = true }

        -- Toggle Fern file explorer (open/close the drawer)
        vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>Fern . -reveal=% -drawer -toggle -width=40<CR>", opts)

        -- Toggle focus between Fern and the editor
        vim.api.nvim_set_keymap("n", "<leader>o", "", {
            callback = function()
                if vim.bo.filetype == "fern" then
                    vim.cmd.wincmd "p"
                else
                    vim.cmd.Fern(".", "-reveal=%", "-drawer", "-width=40")
                end
            end,
            noremap = true,
            silent = true,
        })
    end
}

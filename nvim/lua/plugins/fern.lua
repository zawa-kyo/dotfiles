return {
    "lambdalisue/fern.vim",
    dependencies = {
        "lambdalisue/fern-hijack.vim", -- Automatically replace netrw with Fern
    },
    config = function()
        -- Get the initial working directory as the project root
        local project_root = vim.fn.getcwd()  -- Store the cwd at the time of NeoVim startup

        -- Function to open Fern at project root and reveal the current file
        local function open_fern_with_reveal()
            if vim.bo.filetype == "fern" then
                vim.cmd("bd") -- Close Fern and return to previous window
            else
                vim.cmd("cd " .. project_root) -- Set cwd to project root
                vim.cmd("Fern . -drawer -width=40 -reveal=" .. vim.fn.expand("%:p")) -- Reveal the current file
            end
        end

        -- Key mappings
        vim.keymap.set("n", "<leader>b", open_fern_with_reveal, { noremap = true, silent = true }) -- Toggle Fern
        vim.keymap.set("n", "<leader>o", open_fern_with_reveal, { noremap = true, silent = true }) -- Open Fern with reveal

        -- Set Enter key to open as a child node when in Fern buffer
        vim.cmd([[
            augroup FernCustom
                autocmd!
                autocmd FileType fern nnoremap <buffer> <CR> <Plug>(fern-action-expand)
            augroup END
        ]])
    end
}

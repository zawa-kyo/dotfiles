return {
    "lambdalisue/fern.vim",
    dependencies = {
        "lambdalisue/fern-hijack.vim",
    },
    config = function()
        -- Store the cwd at the time of NeoVim startup
        local project_root = vim.fn.getcwd()

        -- Track last cursor position in file
        local last_file_position = nil

        -- Function to toggle focus to Fern or reveal current file in Fern
        local function toggle_fern_with_reveal()
            if vim.bo.filetype == "fern" then
                -- Move focus back to the file without closing Fern
                vim.cmd.wincmd("p")
                if last_file_position then
                    vim.api.nvim_win_set_cursor(0, last_file_position)
                end
            else
                -- Save the current cursor position in the file
                last_file_position = vim.api.nvim_win_get_cursor(0)

                -- Calculate 25% of the current window width
                local fern_width = math.floor(vim.api.nvim_win_get_width(0) * 0.25)

                -- Defer Fern opening slightly to allow dynamic width to take effect
                vim.defer_fn(function()
                    vim.cmd("cd " .. project_root)
                    vim.cmd("Fern . -drawer -width=" .. fern_width .. " -reveal=" .. vim.fn.expand("%:p"))
                end, 10)
            end
        end

        -- Function to toggle or close Fern
        local function toggle_or_close_fern()
            if vim.bo.filetype == "fern" then
                vim.cmd("bd")                                          -- Close Fern
                if last_file_position then
                    vim.api.nvim_win_set_cursor(0, last_file_position) -- Return to last cursor position
                end
            else
                toggle_fern_with_reveal()
            end
        end

        -- Key mappings
        vim.keymap.set("n", "<leader>b", toggle_or_close_fern, { noremap = true, silent = true })    -- Toggle Fern or close
        vim.keymap.set("n", "<leader>o", toggle_fern_with_reveal, { noremap = true, silent = true }) -- Toggle Fern with reveal

        -- Set Enter key to open file or expand directory when in Fern buffer
        vim.cmd([[
            augroup FernCustom
                autocmd!
                autocmd FileType fern nnoremap <buffer> <CR> <Plug>(fern-action-open) -- Open file or expand directory
            augroup END
        ]])
    end
}

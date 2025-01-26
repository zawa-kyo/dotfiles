local M = {
    "lambdalisue/fern.vim",
    dependencies = {
        "lambdalisue/fern-hijack.vim",
    },
}

-- Store the cwd at the time of NeoVim startup
local project_root = vim.fn.getcwd()
-- Track last cursor position in file
local last_file_position = nil

-- Function to toggle focus to Fern or reveal current file in Fern
function M.toggle_fern_with_reveal()
    -- Move focus back to the file without closing Fern
    if vim.bo.filetype == "fern" then
        -- Move focus back to the file without closing Fern
        vim.cmd.wincmd("p")
        if last_file_position then
            vim.api.nvim_win_set_cursor(0, last_file_position)
        end
    else
        -- Save the current cursor position in the file
        last_file_position = vim.api.nvim_win_get_cursor(0)

        -- Defer Fern opening and dynamically adjust width after opening
        vim.defer_fn(function()
            vim.cmd("cd " .. project_root)
            vim.cmd("Fern . -drawer -reveal=" .. vim.fn.expand("%:p"))

            -- Resize Fern window to 25% of the full window width
            local fern_width = math.floor(vim.o.columns * 0.25)
            vim.cmd("vertical resize " .. fern_width)
        end, 10)
    end
end

-- Function to toggle or close Fern
function M.toggle_or_close_fern()
    if vim.bo.filetype == "fern" then
        vim.cmd("bd") -- Close Fern
        if last_file_position then
            vim.api.nvim_win_set_cursor(0, last_file_position)
        end
    else
        M.toggle_fern_with_reveal()
    end
end

M.config = function()
    -- Set Enter key to open file or expand directory when in Fern buffer
    vim.cmd([[
    augroup FernCustom
      autocmd!
      autocmd FileType fern nnoremap <buffer> <CR> <Plug>(fern-action-open)
    augroup END
  ]])
end

return M

local M = {
    "lambdalisue/fern.vim",

    cond = not vim.g.vscode,

    dependencies = {
        "lambdalisue/fern-hijack.vim",
        "yuki-yano/fern-preview.vim",
    },
}

-- Store the cwd at startup
local project_root = vim.fn.getcwd()
-- Track last file window and cursor position
local last_file_state = nil

-- Toggle focus to Fern or reveal current file
function M.toggle_fern_with_reveal()
    if vim.bo.filetype == "fern" then
        -- Switch focus back to the file
        vim.cmd.wincmd("p")
        if last_file_state and vim.api.nvim_win_is_valid(last_file_state.win) then
            vim.api.nvim_set_current_win(last_file_state.win)
            vim.api.nvim_win_set_cursor(last_file_state.win, last_file_state.pos)
        end
    else
        -- Save current window and cursor position
        last_file_state = {
            win = vim.api.nvim_get_current_win(),
            pos = vim.api.nvim_win_get_cursor(0)
        }
        vim.schedule(function()
            vim.cmd("cd " .. project_root)
            local current_file = vim.fn.expand("%:p")
            if vim.fn.filereadable(current_file) == 1 then
                -- Open Fern and reveal the current file
                vim.cmd("Fern . -drawer -reveal=" .. current_file)
            else
                -- Open Fern normally if file does not exist
                vim.cmd("Fern . -drawer")
            end

            -- Resize Fern window to 25% of the full window width
            local fern_width_ratio = 0.25
            local fern_width = math.floor(vim.o.columns * fern_width_ratio)
            vim.cmd("vertical resize " .. fern_width)
        end)
    end
end

-- Function to toggle or close Fern
function M.toggle_or_close_fern()
    if vim.bo.filetype == "fern" then
        -- Close Fern buffer
        vim.cmd("bd")
        if last_file_state and vim.api.nvim_win_is_valid(last_file_state.win) then
            vim.api.nvim_set_current_win(last_file_state.win)
            vim.api.nvim_win_set_cursor(last_file_state.win, last_file_state.pos)
        end
    else
        M.toggle_fern_with_reveal()
    end
end

M.config = function()
    local fern_augroup = vim.api.nvim_create_augroup("FernCustom", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = fern_augroup,
        pattern = "fern",
        callback = function()
            -- Open file or expand directory in Fern buffer
            vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<Plug>(fern-action-open)", { noremap = false, silent = true })
            -- Toggle preview in Fern buffer
            vim.api.nvim_buf_set_keymap(0, "n", "p", "<Plug>(fern-action-preview:toggle)",
                { noremap = false, silent = true })
        end,
    })
end

return M

local M = {
    "rhysd/git-messenger.vim",
    init = function()
        -- Always use a popup window instead of echoing messages
        vim.g.git_messenger_always_into_popup = true

        -- Use a rounded border for the floating window
        vim.g.git_messenger_floating_win_opts = { border = "rounded" }

        -- Set date format to YYYY/MM/DD HH:MM:SS
        vim.g.git_messenger_date_format = "%Y/%m/%d %H:%M:%S"

        -- Truncate commit message to fit within the floating window
        vim.g.git_messenger_max_popup_width = 80
    end
}

--- Show GitMessenger simply
function M.git_messenger_simple()
    vim.g.git_messenger_include_diff = "none"
    vim.cmd("GitMessenger")
end

--- Show GitMessenger with diff
function M.git_messenger_with_diff()
    vim.g.git_messenger_include_diff = "current"
    vim.g.git_messenger_extra_log_args = "--stat --color=always"
    vim.cmd("GitMessenger")
end

return M

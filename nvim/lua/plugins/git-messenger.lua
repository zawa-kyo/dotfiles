local M = {
    "rhysd/git-messenger.vim",

    lazy = true,
    event = {
        "BufRead",
        "BufNewFile",
    },
    cond = not vim.g.vscode,

    keys = {
        {
            "gm",
            function() require("plugins.git-messenger").git_messenger_simple() end,
            desc = "Show git commit message"
        },
        {
            "gc",
            function() require("plugins.git-messenger").git_messenger_with_diff() end,
            desc = "Show git commit message with diff"
        },
    },

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

--- Show GitMessenger with customizable options
--- @param include_diff string|nil "none" for simple, "current" for diff
--- @param extra_log_args string|nil Additional git log arguments
--- @param template string|nil Custom format for display
function M.git_messenger_show(include_diff, extra_log_args, template)
    -- Set options dynamically based on parameters
    vim.g.git_messenger_include_diff = include_diff or "none"

    if extra_log_args then
        vim.g.git_messenger_extra_log_args = extra_log_args
    end

    if template then
        vim.g.git_messenger_template = template
    end

    -- Execute GitMessenger
    vim.cmd("GitMessenger")
end

--- Show GitMessenger simply (without diff and History)
function M.git_messenger_simple()
    M.git_messenger_show(
        "none",
        nil,
        "Commit: #{commit}\nDate: #{date}\n#{author}\n#{summary}"
    )
end

--- Show GitMessenger with diff and History
function M.git_messenger_with_diff()
    M.git_messenger_show(
        "current",
        "--stat --color=always",
        "History: #{history}\nCommit: #{commit}\nDate: #{date}\n#{author}\n#{summary}"
    )
end

return M

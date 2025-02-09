local M = {
    "ibhagwan/fzf-lua",
    dependencies = {
        "DaikyXendo/nvim-material-icon",
        {
            "ahmedkhalf/project.nvim",
            config = function()
                require("project_nvim").setup({
                    -- Patterns to detect project root
                    patterns = { ".git", "Makefile", "package.json" },
                })
            end,
        },
    },
}

-- Search lines with a check for fern buffer
function M.lines()
    if vim.bo.filetype == "fern" then
        vim.notify("Cannot use :FzfLua lines in fern buffer", vim.log.levels.WARN)
        return
    end

    vim.cmd("FzfLua lines")
end

M.config = function()
    require("fzf-lua").setup({
        files = {
            -- POSIX-compliant options for 'find'
            find_opts = [[-type f]],
        },
        keymap = {
            fzf = {
                ["tab"]       = "down",
                ["ctrl-j"]    = "down",
                ["shift-tab"] = "up",
                ["ctrl-k"]    = "up",
            },
        },
    })
end

return M

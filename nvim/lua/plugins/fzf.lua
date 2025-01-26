local M = {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
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

-- Function to handle <leader>f with a check for fern buffer
function M.fzf_lines_or_notify()
    if vim.bo.filetype == "fern" then
        vim.notify("Cannot use :FzfLua lines in fern buffer", vim.log.levels.WARN)
    else
        vim.cmd("FzfLua lines")
    end
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

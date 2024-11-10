return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        {
            "ahmedkhalf/project.nvim",
            config = function()
                require("project_nvim").setup({
                    patterns = { ".git", "Makefile", "package.json" }, -- Patterns to detect project root
                })
            end,
        }
    },
    config = function()
        require("fzf-lua").setup({
            files = {
                -- POSIX-compliant options for 'find'
                find_opts = [[-type f]]
            },
            keymap = {
                fzf = {
                    ["tab"] = "down",
                    ["ctrl-j"] = "down",
                    ["shift-tab"] = "up",
                    ["ctrl-k"] = "up",
                },
            }
        })

        local opts = { noremap = true, silent = true }

        -- Function to handle <leader>f with a check for fern buffer
        local function fzf_lines_or_notify()
            if vim.bo.filetype == "fern" then
                vim.notify("Cannot use :FzfLua lines in fern buffer", vim.log.levels.WARN)
            else
                vim.cmd("FzfLua lines")
            end
        end

        -- Map <leader>p to trigger file search in the current directory
        vim.api.nvim_set_keymap("n", "<leader>p", ":FzfLua files<CR>", opts)

        -- Map <leader>g to perform a global search across all files
        vim.api.nvim_set_keymap("n", "<leader>g", ":FzfLua live_grep<CR>", opts)

        -- Map <leader>f to search within the current file's contents, with a fern buffer check
        vim.api.nvim_set_keymap("n", "<leader>f", "", {
            noremap = true,
            silent = true,
            callback = fzf_lines_or_notify,
        })

        -- Map <leader>P to list and select from recent projects, changing to the selected directory
        vim.api.nvim_set_keymap("n", "<leader>P", "", {
            noremap = true,
            silent = true,
            callback = fzf_project_list, -- Directly calls the fzf_project_list function as a callback
        })
    end
}

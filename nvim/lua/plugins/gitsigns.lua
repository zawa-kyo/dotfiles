return {
    "lewis6991/gitsigns.nvim",

    lazy = true,
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    cond = not vim.g.vscode,

    config = function()
        require("gitsigns").setup {
            signs = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
            },
            -- Display git blame info for the current line
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 1000,          -- Delay before blame shows
                virt_text_pos = 'eol', -- Display at the end of the line
            },
            -- Only enable signs and line blame, no keybindings for git actions
            on_attach = function(bufnr)
                -- No key mappings are defined, only visual signs and blame are enabled
            end,
        }
    end,
}

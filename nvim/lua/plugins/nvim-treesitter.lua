return {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufNewFile', 'BufRead' },
    cnd = not vim.g.vscode,
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-context',
    },
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = {
                "lua",
                "javascript",
                "typescript",
                "python",
                "java",
                "dart",
                "rust",
            },
            highlight = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = {
                            query = "@function.outer",
                            desc = "Select outer function",
                        },
                        ["if"] = {
                            query = "@function.inner",
                            desc = "Select inner function",
                        },
                        ["ac"] = {
                            query = "@class.outer",
                            desc = "Select outer class",
                        },
                        ["ic"] = {
                            query = "@class.inner",
                            desc = "Select inner class",
                        },
                    }
                },
            }
        }
    end
}

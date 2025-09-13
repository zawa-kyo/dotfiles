vim.scriptencoding = "utf-8"

-- Ensure filetype detection is enabled early
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = nil
vim.cmd("filetype plugin indent on")

-- Fallback syntax highlighting (in case Treesitter/theme misses some groups)
vim.cmd("syntax enable")

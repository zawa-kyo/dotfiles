-- Common options
local opts = { noremap = true, silent = true }

-- LSP functions
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

-- Fern
local fern = require("plugins.fern")
vim.keymap.set("n", "<leader>b", fern.toggle_or_close_fern, opts)
vim.keymap.set("n", "<leader>o", fern.toggle_fern_with_reveal, opts)

-- Toggleterm
vim.api.nvim_set_keymap("n", "<leader>t", ":ToggleTerm direction=horizontal name=desktop<CR>", opts)

-- Fzf
local fzf = require("plugins.fzf")

-- Trigger file search in the current directory
vim.api.nvim_set_keymap("n", "<leader>p", ":FzfLua files<CR>", opts)

-- Perform a global search across all files
vim.api.nvim_set_keymap("n", "<leader>g", ":FzfLua live_grep<CR>", opts)

-- Search within the current file (notify in fern buffer)
vim.api.nvim_set_keymap("n", "<leader>f", "", {
    noremap = true,
    silent = true,
    callback = fzf.fzf_lines_or_notify,
})

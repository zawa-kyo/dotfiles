local M = {}
local opts = { noremap = true, silent = true }

function M.hard_mode()
    vim.keymap.set("n", "<Up>", "<Nop>", opts)
    vim.keymap.set("n", "<Down>", "<Nop>", opts)
    vim.keymap.set("n", "<Left>", "<Nop>", opts)
    vim.keymap.set("n", "<Right>", "<Nop>", opts)
end

function M.easy_mode()
    vim.keymap.set("n", "<Up>", "<Up>", opts)
    vim.keymap.set("n", "<Down>", "<Down>", opts)
    vim.keymap.set("n", "<Left>", "<Left>", opts)
    vim.keymap.set("n", "<Right>", "<Right>", opts)
end

return M

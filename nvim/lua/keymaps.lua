local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- NORMAL MODE:
-- Trial: Better transition to command-line mode
keymap("n", "<leader><leader>", ":", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Make scroll keys intuitive
keymap("n", "<C-k>", "<C-u>", { noremap = false, silent = true })
keymap("n", "<C-j>", "<C-d>", { noremap = false, silent = true })

-- Create new tab
keymap("n", "te", ":tabedit", opts)

-- Move tab
keymap("n", "gh", "gT", opts)
keymap("n", "gl", "gt", opts)

-- Optimize jump
keymap("n", "tl", "<c-]>", opts)
keymap("n", "tl", "<c-t>", opts)

-- Move tab
keymap("n", "gh", "gT", opts)
keymap("n", "gl", "gt", opts)

-- Look around
keymap("n", "zk", "zb", opts)
keymap("n", "zj", "zt", opts)

-- Split window
keymap("n", "split", ":split<Return><C-w>w", opts)
keymap("n", "splitv", ":vsplit<Return><C-w>w", opts)

-- Select all
keymap("v", ",", "<Esc>ggVG", opts)

-- Do not yank with x
keymap("n", "x", '"_x', opts)

-- ファイル/行の端に行く
keymap("n", "<C-j>", "G", opts)
keymap("n", "<C-k>", "gg", opts)
keymap("n", "<C-h>", "^", opts)
keymap("n", "<C-l>", "$", opts)

-- Move effectively
keymap("n", "J", "10j", opts)
keymap("n", "K", "10k", opts)
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

-- Optimize redo
keymap("n", "U", "<C-r>", opts)

-- ESC 2回でハイライトを停止
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- INSERT MODE:
-- コンマの後に自動的にスペースを挿入
keymap("i", ",", ",<Space>", opts)

-- VISUAL MODE:
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- ビジュアルモード時vで行末まで選択
keymap("v", "v", "$h", opts)

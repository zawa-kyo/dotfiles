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
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

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
keymap("n", "<Space>j", "G", opts)
keymap("n", "<Space>k", "gg", opts)
keymap("n", "<Space>h", "^", opts)
keymap("n", "<Space>l", "$", opts)

-- Move effectively
keymap("n", "J", "10j", opts)
keymap("n", "K", "10k", opts)
keymap("n", "H", "10h", opts)
keymap("n", "L", "10l", opts)

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

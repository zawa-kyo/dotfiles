--------------------
-- Utils
--------------------

-- Load utils
local utils = require("config.utils")

-- Rename variables for clarity
local opts = utils.getOpts
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts())
vim.g.mapleader = " "
vim.g.maplocalleader = " "


--------------------
-- Docs
--------------------

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',


--------------------
-- Normal Mode
--------------------

-- Better transition to command-line mode
-- Note: Enabling ‘silent’ may cause rendering delay
keymap("n", "<leader><leader>", ":", opts("Show command-line mode", true, false))

-- Better window navigation
keymap("n", "<leader>h", "<C-w>h", opts("Move to the left window"))
keymap("n", "<leader>j", "<C-w>j", opts("Move to the bottom window"))
keymap("n", "<leader>k", "<C-w>k", opts("Move to the top window"))
keymap("n", "<leader>l", "<C-w>l", opts("Move to the right window"))

-- Make scroll keys intuitive
keymap("n", "<C-k>", "<C-u>", { noremap = false, silent = true }, opts("Scroll up"))
keymap("n", "<C-j>", "<C-d>", { noremap = false, silent = true }, opts("Scroll down"))

-- Select all
keymap("n", "<leader>a", "ggVG", opts("Select all"))
keymap("v", ",", "<Esc>ggVG", opts("Select all"))

-- Remap 'j'/'k' for wrapped lines
keymap("n", "j", "gj", opts("Move down wrapped lines"))
keymap("n", "k", "gk", opts("Move up wrapped lines"))

-- Move to the top/bottom line
keymap("n", "gj", "G", opts("Move to the bottom line"))
keymap("n", "gk", "gg", opts("Move to the top line"))

-- Move to the next/previous location
vim.keymap.set("n", "gp", "<C-o>", opts("Jump to previous location"))
vim.keymap.set("n", "gn", "<C-i>", opts("Jump to next location"))

-- Optimize to jump to the matching pair
keymap("n", "M", "%", opts("Jump to the matching pair"))

-- Copy to clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', opts("Copy to clipboard"))

-- Tab operations
keymap("n", "tn", ":tabedit", opts("Create a new tab"))
keymap("n", "gh", "gT", opts("Move to the left tab"))
keymap("n", "gl", "gt", opts("Move to the right tab"))

-- Look around
keymap("n", "zk", "zb", opts("Look up"))
keymap("n", "zj", "zt", opts("Look down"))

-- Split window
keymap("n", "split", ":split<Return><C-w>w", opts("Split window horizontally"))
keymap("n", "splitv", ":vsplit<Return><C-w>w", opts("Split window vertically"))

-- Do not yank with x
keymap("n", "x", '"_x', opts("Do not yank with x"))

-- Move effectively
keymap("n", "J", "10j", opts("Move down 10 lines"))
keymap("n", "K", "10k", opts("Move up 10 lines"))
keymap("n", "H", "^", opts("Move to the beginning of the line"))
keymap("n", "L", "$", opts("Move to the end of the line"))

-- Optimize redo
keymap("n", "U", "<C-r>", opts("Redo"))


--------------------
-- Insert Mode
--------------------

-- コンマの後に自動的にスペースを挿入
keymap("i", ",", ",<Space>", opts("Insert a space after a comma"))


--------------------
-- Visual Mode
--------------------

-- Stay in indent mode
keymap("v", "<", "<gv", opts())
keymap("v", ">", ">gv", opts())

-- ビジュアルモード時vで行末まで選択
keymap("v", "v", "$h", opts("Select to the end of the line"))

-- aで前後のスペースを巻き添えにしない
for _, quote in ipairs({ '"', "'", "`" }) do
    keymap({ "x", "o" }, "a" .. quote, "2i" .. quote, opts())
end

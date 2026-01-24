local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

--------------------
-- All Modes
--------------------

local all_modes_without_terminal = { "n", "i", "v", "x", "o", "c", "s" }

-- Disable arrow keys to encourage hjkl
keymap(all_modes_without_terminal, "<Up>", "<Nop>", opts("Nop"))
keymap(all_modes_without_terminal, "<Down>", "<Nop>", opts("Nop"))
keymap(all_modes_without_terminal, "<Left>", "<Nop>", opts("Nop"))
keymap(all_modes_without_terminal, "<Right>", "<Nop>", opts("Nop"))

--------------------
-- Normal Mode
--------------------

-- Better transition to command-line mode
-- Note: Enabling ‘silent’ may cause rendering delay
keymap("n", "<leader><leader>", ":", opts("Show command-line mode", true, false, nil))

-- File operations
keymap("n", "<leader>w", "<Cmd>write<CR>", opts("Write current buffer"))
keymap("n", "<leader>q", "<Cmd>quit<CR>", opts("Quit window"))

-- Window navigation (Ctrl+h/j/k/l)
keymap("n", "<C-h>", "<C-w>h", opts("Go to left window"))
keymap("n", "<C-j>", "<C-w>j", opts("Go to bottom window"))
keymap("n", "<C-k>", "<C-w>k", opts("Go to top window"))
keymap("n", "<C-l>", "<C-w>l", opts("Go to right window"))
keymap("n", "[w", "<C-w>W", opts("Go to previous window"))
keymap("n", "]w", "<C-w>w", opts("Go to next window"))

-- Window operations (<leader>w…)
keymap("n", "<leader>ws", ":split<CR><C-w>w", opts("Split window horizontally"))
keymap("n", "<leader>wv", ":vsplit<CR><C-w>w", opts("Split window vertically"))
keymap("n", "<leader>w=", "<C-w>=", opts("Equalize window sizes"))
keymap("n", "<leader>wq", "<C-w>q", opts("Close the current window"))
keymap("n", "<leader>wo", "<C-w>o", opts("Close other windows"))
keymap("n", "<leader>wx", "<C-w>x", opts("Swap with adjacent window"))
keymap("n", "<leader>w<", "5<C-w><", opts("Decrease window width"))
keymap("n", "<leader>w>", "5<C-w>>", opts("Increase window width"))
keymap("n", "<leader>w-", "5<C-w>-", opts("Decrease window height"))
keymap("n", "<leader>w+", "5<C-w>+", opts("Increase window height"))

-- Buffer operations (<leader>b…)
keymap("n", "<leader>bb", "<Cmd>ls<CR>", opts("Browse buffers"))
keymap("n", "<leader>bd", "<Cmd>bdelete<CR>", opts("Delete buffer"))
keymap("n", "<leader>bq", "<Cmd>bdelete<CR>", opts("Delete buffer"))
keymap("n", "<leader>br", "<Cmd>edit!<CR>", opts("Reload buffer"))
keymap("n", "]b", "<Cmd>bnext<CR>", opts("Go to next buffer"))
keymap("n", "[b", "<Cmd>bprevious<CR>", opts("Go to previous buffer"))

-- Tab operations (<leader>t…)
keymap("n", "<leader>tn", "<Cmd>tabnew<CR>", opts("Open new tab"))
keymap("n", "<leader>ts", "<Cmd>tab split<CR>", opts("Split to new tab"))
keymap("n", "<leader>tq", "<Cmd>tabclose<CR>", opts("Close tab"))
keymap("n", "]t", "gt", opts("Go to next tab"))
keymap("n", "[t", "gT", opts("Go to previous tab"))

-- Disable default substitute to free up "s/S", "r/R" prefix
keymap("n", "s", "<Nop>", opts("Disable substitute"))
keymap("n", "S", "<Nop>", opts("Disable substitute line"))
keymap("n", "r", "<Nop>", opts("Disable replace"))
keymap("n", "R", "<Nop>", opts("Disable replace line"))

-- Toggle fold column
keymap("n", "tF", function()
  vim.wo.foldcolumn = vim.wo.foldcolumn == "0" and "1" or "0"
end, opts("Toggle fold column"))

-- Toggle relative numbers
keymap("n", "tR", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, opts("Toggle relative numbers"))

-- Wrapped lines: move by screen line
keymap("n", "j", "gj", opts("Move down wrapped lines"))
keymap("n", "k", "gk", opts("Move up wrapped lines"))

-- Jump history
keymap("n", "]l", "<C-i>", opts("Jump to next location"))
keymap("n", "[l", "<C-o>", opts("Jump to previous location"))
keymap("n", "]]", "<C-i>", opts("Jump to next location"))
keymap("n", "[[", "<C-o>", opts("Jump to previous location"))

-- Sections
keymap("n", "]s", "<Cmd>normal! ]]<CR>", opts("Go to next section"))
keymap("n", "[s", "<Cmd>normal! [[<CR>", opts("Go to previous section"))

-- Marks (use M to avoid clashing with the modify prefix)
keymap("n", "M", "m", opts("Set mark"))

-- Match pairs (align with cycle-style [ ] prefix)
keymap("n", "]p", "%", opts("Go to matching pair"))
keymap("n", "[p", "%", opts("Go to matching pair"))

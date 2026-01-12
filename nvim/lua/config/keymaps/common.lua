local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

--------------------
-- All Modes
--------------------

local all_modes = { "n", "i", "v", "x", "o", "t", "c", "s" }

-- Disable arrow keys to encourage hjkl
keymap(all_modes, "<Up>", "<Nop>", opts("Nop"))
keymap(all_modes, "<Down>", "<Nop>", opts("Nop"))
keymap(all_modes, "<Left>", "<Nop>", opts("Nop"))
keymap(all_modes, "<Right>", "<Nop>", opts("Nop"))

--------------------
-- Normal Mode
--------------------

-- Better transition to command-line mode
-- Note: Enabling ‘silent’ may cause rendering delay
keymap("n", "<leader><leader>", ":", opts("Show command-line mode", true, false, nil))

-- Window navigation (Ctrl+h/j/k/l or <leader>H/J/K/L)
keymap("n", "<C-h>", "<C-w>h", opts("Go to left window"))
keymap("n", "<C-j>", "<C-w>j", opts("Go to bottom window"))
keymap("n", "<C-k>", "<C-w>k", opts("Go to top window"))
keymap("n", "<C-l>", "<C-w>l", opts("Go to right window"))
keymap("n", "<leader>H", "<C-w>h", opts("Go to the left window"))
keymap("n", "<leader>J", "<C-w>j", opts("Go to the bottom window"))
keymap("n", "<leader>K", "<C-w>k", opts("Go to the top window"))
keymap("n", "<leader>L", "<C-w>l", opts("Go to the right window"))

-- Window operations (<leader>w…)
keymap("n", "<leader>ws", ":split<CR><C-w>w", opts("Split window horizontally"))
keymap("n", "<leader>wv", ":vsplit<CR><C-w>w", opts("Split window vertically"))
keymap("n", "<leader>w=", "<C-w>=", opts("Equalize window sizes"))
keymap("n", "<leader>wq", "<C-w>q", opts("Close the current window"))

-- Resize (use shifted H/J/K/L to imply “bigger action”)
keymap("n", "<leader>wH", "5<C-w><", opts("Decrease window width"))
keymap("n", "<leader>wL", "5<C-w>>", opts("Increase window width"))
keymap("n", "<leader>wJ", "5<C-w>-", opts("Decrease window height"))
keymap("n", "<leader>wK", "5<C-w>+", opts("Increase window height"))

-- Buffer operations (<leader>b…)
keymap("n", "<leader>bl", "<Cmd>bnext<CR>", opts("Go to next buffer"))
keymap("n", "<leader>bh", "<Cmd>bprevious<CR>", opts("Go to previous buffer"))
keymap("n", "<leader>bb", "<Cmd>ls<CR>", opts("List buffers"))
keymap("n", "<leader>bd", "<Cmd>bdelete<CR>", opts("Delete buffer"))

-- Tab operations (<leader>t…)
keymap("n", "<leader>tn", ":tabedit", opts("Open new tab (enter filename)"))
keymap("n", "<leader>tl", "gt", opts("Go to next tab"))
keymap("n", "<leader>th", "gT", opts("Go to previous tab"))
keymap("n", "<leader>tq", "<Cmd>tabclose<CR>", opts("Close tab"))

-- Disable default substitute to free up "s/S" prefix
keymap("n", "s", "<Nop>", opts("Disable substitute"))
keymap("n", "S", "<Nop>", opts("Disable substitute line"))

-- Disable default replace to free up "r/R" prefix
keymap("n", "r", "<Nop>", opts("Disable replace"))
keymap("n", "R", "<Nop>", opts("Disable replace line"))

-- Toggle fold column
keymap("n", "tf", function()
  vim.wo.foldcolumn = vim.wo.foldcolumn == "0" and "1" or "0"
end, opts("Toggle fold column"))

-- Toggle relative numbers
keymap("n", "tr", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, opts("Toggle relative numbers"))

-- Wrapped lines: move by screen line
keymap("n", "j", "gj", opts("Move down wrapped lines"))
keymap("n", "k", "gk", opts("Move up wrapped lines"))

-- Jump history (keep gp/gP)
keymap("n", "gp", "<C-o>", opts("Jump to previous location"))
keymap("n", "gP", "<C-i>", opts("Jump to next location"))
keymap("n", "gn", "<C-i>", opts("Jump to next location"))
keymap("n", "gN", "<C-o>", opts("Jump to previous location"))

-- Marks (use M to avoid clashing with the modify prefix)
keymap("n", "M", "m", opts("Set mark"))

-- Match pairs (align with cycle-style [ ] prefix)
keymap("n", "]p", "%", opts("Go to matching pair"))
keymap("n", "[p", "%", opts("Go to matching pair"))

-- Clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', opts("Copy to clipboard"))

-- Look around
keymap("n", "zk", "zb", opts("Look up"))
keymap("n", "zj", "zt", opts("Look down"))

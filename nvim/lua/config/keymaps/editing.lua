local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

--------------------
-- Normal Mode
--------------------

-- Select all
keymap("n", "<leader>a", "ggVG", opts("Select all"))
keymap("v", ",", "<Esc>ggVG", opts("Select all"))

-- Do not yank with x
keymap("n", "x", '"_x', opts("Do not yank with x"))
keymap("n", "<BS>", '"_x', opts("Do not yank with backspace"))

-- Create new lines without reaching for o/O
keymap("n", "<CR>", "o", opts("Insert new line below"))
keymap("n", "<S-CR>", "O", opts("Insert new line above"))

-- Redo
keymap("n", "U", "<C-r>", opts("Redo"))

-- Move current line up/down
keymap("n", "mK", "<Cmd>move -2<CR>==", opts("Move current line up"))
keymap("n", "mJ", "<Cmd>move +1<CR>==", opts("Move current line down"))

-- Indent after pasting
keymap("n", "p", "]p`]", opts("Indent after pasting"))
keymap("n", "P", "]P`]", opts("Indent after pasting"))

-- Auto-indent when starting edit on an empty line
keymap("n", "i", function()
  return vim.fn.getline(".") == "" and '"_cc' or "i"
end, opts("Indent when starting editing on an empty line", nil, nil, true))
keymap("n", "A", function()
  return vim.fn.getline(".") == "" and '"_cc' or "A"
end, opts("Indent when starting editing on an empty line", nil, nil, true))

--------------------
-- Insert Mode
--------------------

-- Auto space after comma
keymap("i", ",", ",<Space>", opts("Insert a space after a comma"))

-- Remap jj to Esc
keymap("i", "jj", "<Esc>", opts("Escape", true, false, nil))

--------------------
-- Visual Mode
--------------------

-- Indentation
keymap("v", "<", "<gv", opts("Add indentation"))
keymap("v", ">", ">gv", opts("Reduce indentation"))

-- Align Visual behavior
keymap("v", "v", "<Esc>V", opts("Select the whole line"))
keymap("n", "V", "v$", opts("Select until the end of the line"))

-- Preserve cursor on yank
keymap("x", "y", "mzy`z", opts("Yank the selected text"))

-- Delete words with backspace
keymap({ "v", "x" }, "<BS>", "_d", opts("Delete selection with backspace"))

-- Move selected lines
keymap("x", "K", ":move '<-2<CR>gv=gv", opts("Move selected lines up"))
keymap("x", "J", ":move '>+1<CR>gv=gv", opts("Move selected lines down"))

-- Text objects: avoid leading/trailing spaces when appending
for _, quote in ipairs({ '"', "'", "`" }) do
  keymap({ "x", "o" }, "a" .. quote, "2i" .. quote, opts("Append without leading/trailing spaces"))
end

--------------------
-- Text Object
--------------------

-- Between spaces
keymap("o", "i<space>", "iW", opts("Select words between spaces"))
keymap("x", "i<space>", "iW", opts("Select words between spaces"))

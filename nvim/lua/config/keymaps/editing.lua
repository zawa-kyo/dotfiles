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
keymap("n", "U", "<Cmd>redo<CR>", opts("Redo"))

-- Move current line up/down
keymap("n", "mK", "<Cmd>move -2<CR>==", opts("Move current line up"))
keymap("n", "mJ", "<Cmd>move +1<CR>==", opts("Move current line down"))

-- Paste and move to the end
keymap("n", "p", "p`]", opts("Paste and move to the end"))
keymap("n", "P", "P`]", opts("Paste and move to the end"))

-- Auto-indent when starting edit on an empty line
keymap("n", "i", function()
  return vim.fn.getline(".") == "" and '"_cc' or "i"
end, opts("Indent when starting editing on an empty line", nil, nil, true))
keymap("n", "A", function()
  return vim.fn.getline(".") == "" and '"_cc' or "A"
end, opts("Indent when starting editing on an empty line", nil, nil, true))

-- Override V behavior
keymap("n", "V", "v$", opts("Select until the end of the line"))

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
keymap("x", "<", "<gv", opts("Add indentation"))
keymap("x", ">", ">gv", opts("Reduce indentation"))

-- Align Visual behavior
keymap("x", "v", "<Esc>V", opts("Select the whole line"))

-- Paste without replacing the unnamed register
keymap("x", "p", '"_dP', opts("Paste without changing register"))

-- Preserve cursor on yank
keymap("x", "y", "mzy`z", opts("Yank the selected text"))

-- Yank file path and line range for AI references
keymap("x", "Y", function()
  local path = vim.fn.expand("%:.")
  if path == "" then
    path = "No Name"
  end

  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local text = string.format("%s:%d-%d", path, start_line, end_line)
  vim.fn.setreg('"', text)
  vim.fn.setreg("0", text)
  if vim.o.clipboard:match("unnamedplus") then
    vim.fn.setreg("+", text)
  elseif vim.o.clipboard:match("unnamed") then
    vim.fn.setreg("*", text)
  end
end, opts("Yank file path and line range"))

-- Delete words with backspace
keymap("x", "<BS>", "_d", opts("Delete selection with backspace"))

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
keymap({ "o", "x" }, "i<space>", "iW", opts("Select words between spaces"))

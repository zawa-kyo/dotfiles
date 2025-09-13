--------------------
-- Utils
--------------------

-- Load utils
local utils = require("config.utils")

-- Rename variables for clarity
local opts = utils.getOpts
local keymap = vim.keymap.set

--Remap space to leader key
keymap("", "<Space>", "<Nop>", opts("Nop"))
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
keymap("n", "<leader><leader>", ":", opts("Show command-line mode", true, false, nil))

-- Better window navigation
keymap("n", "<leader>h", "<C-w>h", opts("Move to the left window"))
keymap("n", "<leader>j", "<C-w>j", opts("Move to the bottom window"))
keymap("n", "<leader>k", "<C-w>k", opts("Move to the top window"))
keymap("n", "<leader>l", "<C-w>l", opts("Move to the right window"))

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
keymap("n", "gp", "<C-o>", opts("Jump to previous location"))
keymap("n", "gn", "<C-i>", opts("Jump to next location"))

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
keymap("n", "s", "<Nop>", opts("Nop"))
keymap("n", "ss", ":split<Return><C-w>w", opts("Split window horizontally"))
keymap("n", "sv", ":vsplit<Return><C-w>w", opts("Split window vertically"))

-- Resize window
keymap("n", "sh", "5<C-w><", opts("Decrease window width"))
keymap("n", "sl", "5<C-w>>", opts("Increase window width"))
keymap("n", "sj", "5<C-w>-", opts("Decrease window height"))
keymap("n", "sk", "5<C-w>+", opts("Increase window height"))

-- Equalize window sizes
keymap("n", "se", "<C-w>=", opts("Equalize window sizes"))

-- Do not yank with x
keymap("n", "x", '"_x', opts("Do not yank with x"))

-- Move to the beginning/end of the line
keymap("n", "H", "^", opts("Move to the beginning of the line"))
keymap("n", "L", "$", opts("Move to the end of the line"))

-- Optimize redo
keymap("n", "U", "<C-r>", opts("Redo"))

-- Move current line up/down in normal mode
keymap("n", "<C-k>", "<Cmd>move -2<CR>==", opts("Move current line up"))
keymap("n", "<C-j>", "<Cmd>move +1<CR>==", opts("Move current line down"))

-- Indent after pasting
keymap("n", "p", "]p`]", opts("Indent after pasting"))
keymap("n", "P", "]P`]", opts("Indent after pasting"))

-- Automatically indent when starting editing on an empty line
keymap("n", "i", function()
  return vim.fn.getline(".") == "" and '"_cc' or "i"
end, opts("Indent when starting editing on an empty line", nil, nil, true))
keymap("n", "A", function()
  return vim.fn.getline(".") == "" and '"_cc' or "A"
end, opts("Indent when starting editing on an empty line", nil, nil, true))

--------------------
-- Insert Mode
--------------------

-- Automatically insert a space after a comma
keymap("i", ",", ",<Space>", opts("Insert a space after a comma"))

-- Remap jj to Esc
keymap("i", "jj", "<Esc>", opts("Escape", true, false, nil))

--------------------
-- Visual Mode
--------------------

-- Adjust indentation consecutively.
keymap("v", "<", "<gv", opts("Add indentation"))
keymap("v", ">", ">gv", opts("Reduce indentation"))

-- Align the behavior of Visual Mode with `c` and `d`.
keymap("v", "v", "<Esc>V", opts("Select the whole line"))
keymap("n", "V", "v$", opts("Select until the end of the line"))

-- Save the cursor position when yanking
keymap("x", "y", "mzy`z", opts("Yank the selected text"))

-- Move selected lines up/down in visual mode
keymap("x", "<C-k>", ":move '<-2<CR>gv=gv", opts("Move selected lines up"))
keymap("x", "<C-j>", ":move '>+1<CR>gv=gv", opts("Move selected lines down"))

-- Prevent leading/trailing spaces from being included when appending
for _, quote in ipairs({ '"', "'", "`" }) do
  keymap({ "x", "o" }, "a" .. quote, "2i" .. quote, opts("Append without leading/trailing spaces"))
end

--------------------
-- Text Object
--------------------

-- Select words between spaces
keymap("o", "i<space>", "iW", opts("Select words between spaces"))
keymap("x", "i<space>", "iW", opts("Select words between spaces"))

--------------------
-- Escape: Close Helpers
--------------------

-- Close hover in the hover
local function close_hover_in_hover()
  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(current_win, true)
end

-- Close hover out of the hover
local function close_hover_out_of_hover()
  vim.api.nvim_feedkeys("hl", "n", false)
end

-- Check if the cursor is currently in a floating window (e.g., an LSP hover)
-- @return boolean
local function is_cursor_in_hover()
  local current_win = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(current_win)
  return config.relative ~= ""
end

-- Handle <Esc>: close hover or clear search highlight
local function close_window()
  if is_cursor_in_hover() then
    close_hover_in_hover()
    return
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      close_hover_out_of_hover()
      return
    end
  end

  if vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
    return
  end
end

keymap("n", "<Esc>", close_window, opts("Close hover/clear search"))

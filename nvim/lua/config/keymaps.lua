--------------------
-- Utils
--------------------

-- Load utils
local utils = require("config.utils")

-- Rename variables for clarity
local opts = utils.getOpts
local keymap = vim.keymap.set

-- Remap space to leader key
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
--
-- Prefix design (movement/navigation):
--   <leader>w … Window ops (move/split/resize/equalize/close)
--   <leader>t … Tab ops (new/move/close)
--   <leader>b … Buffer ops (next/prev/list/delete)
--   g*        … “Jump” semantics (jumplist/marks) — keep gp/gP
--   ] / [     … “Next / Previous” common UI (diagnostic/quickfix/loclist/…)
--   n/N       … Keep default search repeat
--   Hop       … f/F (to char), s/S (t/T-equivalent: before/after the char)
--   *t is reserved for tabs; avoid collisions with Hop by using s/S

--------------------
-- Normal Mode
--------------------

-- Better transition to command-line mode
-- Note: Enabling ‘silent’ may cause rendering delay
keymap("n", "<leader><leader>", ":", opts("Show command-line mode", true, false, nil))

-- Window navigation (Ctrl+h/j/k/l or <leader>H/J/K/J)
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

-- Select all
keymap("n", "<leader>a", "ggVG", opts("Select all"))
keymap("v", ",", "<Esc>ggVG", opts("Select all"))

-- Wrapped lines: move by screen line
keymap("n", "j", "gj", opts("Move down wrapped lines"))
keymap("n", "k", "gk", opts("Move up wrapped lines"))

-- Jump history (keep gp/gP)
keymap("n", "gp", "<C-o>", opts("Jump to previous location"))
keymap("n", "gP", "<C-i>", opts("Jump to next location"))
keymap("n", "gn", "<C-i>", opts("Jump to next location"))
keymap("n", "gN", "<C-o>", opts("Jump to previous location"))

-- Match pairs
keymap("n", "M", "%", opts("Jump to the matching pair"))

-- Clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', opts("Copy to clipboard"))

-- Look around
keymap("n", "zk", "zb", opts("Look up"))
keymap("n", "zj", "zt", opts("Look down"))

-- “Next/Prev” conventions
-- Diagnostics
keymap("n", "]d", function()
  vim.diagnostic.goto_next({ float = false })
end, opts("Go to next diagnostic"))
keymap("n", "[d", function()
  vim.diagnostic.goto_prev({ float = false })
end, opts("Go to previous diagnostic"))

if not vim.g.vscode then
  keymap("n", "<leader>d", vim.diagnostic.open_float, opts("Open diagnostic float"))
else
  utils.vscode_map("<leader>d", "workbench.actions.view.problems", "Open Problems view (VSCode)")
end

-- Quickfix / Loclist
keymap("n", "]q", "<Cmd>cnext<CR>", opts("Go to next quickfix item"))
keymap("n", "[q", "<Cmd>cprev<CR>", opts("Go to previous quickfix item"))
keymap("n", "<leader>qq", "<Cmd>copen<CR>", opts("Open quickfix"))
keymap("n", "<leader>qQ", "<Cmd>cclose<CR>", opts("Close quickfix"))
keymap("n", "]l", "<Cmd>lnext<CR>", opts("Go to next location list item"))
keymap("n", "[l", "<Cmd>lprev<CR>", opts("Go to previous location list item"))
keymap("n", "<leader>ll", "<Cmd>lopen<CR>", opts("Open location list"))
keymap("n", "<leader>lL", "<Cmd>lclose<CR>", opts("Close location list"))

-- Do not yank with x
keymap("n", "x", '"_x', opts("Do not yank with x"))
keymap("n", "-", "<Cmd>FzfLua keymaps<CR>", opts("Find keymaps via fzf"))

-- Line begin/end
keymap("n", "H", "^", opts("Move to the beginning of the line"))
keymap("n", "L", "$", opts("Move to the end of the line"))

-- Create new lines without reaching for o/O
keymap("n", "<CR>", "o", opts("Insert new line below"))
keymap("n", "<S-CR>", "O", opts("Insert new line above"))

-- Redo
keymap("n", "U", "<C-r>", opts("Redo"))

-- Move current line up/down
keymap("n", "<C-k>", "<Cmd>move -2<CR>==", opts("Move current line up"))
keymap("n", "<C-j>", "<Cmd>move +1<CR>==", opts("Move current line down"))

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

keymap("n", "<Esc>", close_window, opts("Close hover or clear search highlight"))

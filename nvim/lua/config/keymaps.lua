-- Get options with a description
-- TODO: refactor this to a separate file
local function opts(desc)
    -- Clone opts() to avoid modifying the original table
    local options = { noremap = true, silent = true }

    if desc then
        options.desc = desc
    end
    return options
end

--local keymap = vim.keymap
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts())
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
keymap("n", "<leader><leader>", ":", opts())

-- Better window navigation
keymap("n", "<leader>h", "<C-w>h", opts())
keymap("n", "<leader>j", "<C-w>j", opts())
keymap("n", "<leader>k", "<C-w>k", opts())
keymap("n", "<leader>l", "<C-w>l", opts())

-- Make scroll keys intuitive
keymap("n", "<C-k>", "<C-u>", { noremap = false, silent = true })
keymap("n", "<C-j>", "<C-d>", { noremap = false, silent = true })

-- Select all
keymap("n", "<leader>a", "ggVG", opts())

-- Remap 'j'/'k' for wrapped lines
keymap("n", "j", "gj", opts())
keymap("n", "k", "gk", opts())

-- Move to the top/bottom line
keymap("n", "gj", "G", opts())
keymap("n", "gk", "gg", opts())

-- Optimize jump
keymap("n", "tl", "<c-]>", opts())
keymap("n", "tl", "<c-t>", opts())

-- Optimize to jump to the matching pair
keymap("n", "M", "%", opts("Jump to the matching pair"))

-- Copy to clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', opts())

-- Tab operations
keymap("n", "tn", ":tabedit", opts("Create a new tab"))
keymap("n", "th", "gT", opts("Move to the left tab"))
keymap("n", "tl", "gt", opts("Move to the right tab"))

-- Look around
keymap("n", "zk", "zb", opts())
keymap("n", "zj", "zt", opts())

-- Split window
keymap("n", "split", ":split<Return><C-w>w", opts())
keymap("n", "splitv", ":vsplit<Return><C-w>w", opts())

-- Select all
keymap("v", ",", "<Esc>ggVG", opts())

-- Do not yank with x
keymap("n", "x", '"_x', opts())

-- Move effectively
keymap("n", "J", "10j", opts())
keymap("n", "K", "10k", opts())
keymap("n", "H", "^", opts())
keymap("n", "L", "$", opts())

-- Optimize redo
keymap("n", "U", "<C-r>", opts())

-- INSERT MODE:
-- コンマの後に自動的にスペースを挿入
keymap("i", ",", ",<Space>", opts())

-- VISUAL MODE:
-- Stay in indent mode
keymap("v", "<", "<gv", opts())
keymap("v", ">", ">gv", opts())

-- ビジュアルモード時vで行末まで選択
keymap("v", "v", "$h", opts())

-- aで前後のスペースを巻き添えにしない
for _, quote in ipairs({ '"', "'", "`" }) do
    keymap({ "x", "o" }, "a" .. quote, "2i" .. quote, opts())
end

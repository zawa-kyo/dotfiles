-- Load utils
local utils = require("config.utils")

-- Rename variables for clarity
local opts = utils.getOpts

-- Close hover in the hover
local function close_hover_in_hover()
    -- Close the current floating window directly
    -- `vim.api.nvim_feedkeys("q", "n", false)` does not work
    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_close(current_win, true)
end

-- Close hover out of the hover
local function close_hover_out_of_hover()
    vim.api.nvim_feedkeys("hl", "n", false)
end

--- Check if the cursor is currently in a floating window (e.g., an LSP hover)
---@return boolean
local function is_cursor_in_hover()
    local current_win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(current_win)
    -- If `relative` is not an empty string, this window is floating
    return config.relative ~= ""
end


--------------------
-- Common Actions
--------------------

-- Function to handle <Esc> key behavior
-- Performs one action and skips subsequent ones
local function close_window()
    -- Close hover if cursor is in hover
    if is_cursor_in_hover() then
        close_hover_in_hover()
        return
    end

    -- Close hover if cursor out of hover
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            close_hover_out_of_hover()
            return
        end
    end

    -- Disable highlighting
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
        return
    end
end

vim.keymap.set("n", "<Esc>", close_window, opts())


--------------------
-- LSP
--------------------

vim.keymap.set(
    'n', 'K', vim.lsp.buf.hover,
    opts("Show hover information")
)
vim.keymap.set(
    "n", "gf", vim.lsp.buf.format,
    opts("Format the current file")
)
vim.keymap.set(
    "n", "gr", vim.lsp.buf.references,
    opts("Show references")
)
vim.keymap.set(
    "n", "gd", vim.lsp.buf.definition,
    opts("Go to definition")
)
vim.keymap.set(
    "n", "gD", vim.lsp.buf.declaration,
    opts("Go to declaration")
)
vim.keymap.set(
    "n", "gi", vim.lsp.buf.implementation,
    opts("Go to implementation")
)
vim.keymap.set(
    "n", "gt", vim.lsp.buf.type_definition,
    opts("Go to type definition")
)
vim.keymap.set(
    "n", "rn", vim.lsp.buf.rename,
    opts("Rename the symbol under cursor")
)
vim.keymap.set(
    "n", "ga", vim.lsp.buf.code_action,
    opts("Show available code actions")
)
vim.keymap.set(
    "n", "ge", vim.diagnostic.open_float,
    opts("Show diagnostics")
)
vim.keymap.set(
    "n", "g]", vim.diagnostic.goto_next,
    opts("Go to next diagnostic issue")
)
vim.keymap.set(
    "n", "g[", vim.diagnostic.goto_prev,
    opts("Go to previous diagnostic issue")
)


--------------------
-- Fern
--------------------

-- Load the plugin
local fern = require("plugins.fern")

-- Open file or expand directory when in Fern buffer
vim.keymap.set("n", "<leader>b", fern.toggle_or_close_fern, opts())

-- Toggle focus to Fern or reveal current file in Fern
vim.keymap.set("n", "<leader>o", fern.toggle_fern_with_reveal, opts())


--------------------
-- Toggleterm
--------------------

-- Open a terminal in a horizontal split
vim.keymap.set("n", "<leader>t", ":ToggleTerm direction=horizontal name=desktop<CR>", opts())


--------------------
-- Fzf
--------------------

-- Load the plugin
local fzf = require("plugins.fzf")

-- Trigger file search in the current directory
vim.keymap.set(
    "n", "<leader>p", ":FzfLua files<CR>",
    opts("Search files in the current directory")
)

-- Perform a global search across all files
vim.keymap.set(
    "n", "<leader>g", ":FzfLua live_grep<CR>",
    opts("Search text in all files")
)

-- Search within the current file (notify in fern buffer)
vim.keymap.set(
    "n", "<leader>f", fzf.lines,
    opts("Search text in the current file")
)


--------------------
-- Neoscroll
--------------------

-- Load the plugin
local neoscroll = require("neoscroll")

local keymap = {
    ["<C-u>"]   = function() neoscroll.ctrl_u({ duration = 250 }) end,
    ["<C-d>"]   = function() neoscroll.ctrl_d({ duration = 250 }) end,
    ["<C-b>"]   = function() neoscroll.ctrl_b({ duration = 550 }) end,
    ["<C-f>"]   = function() neoscroll.ctrl_f({ duration = 550 }) end,
    ["<Tab>"]   = function() neoscroll.ctrl_d({ duration = 550 }) end,
    ["<S-Tab>"] = function() neoscroll.ctrl_u({ duration = 550 }) end,
}

for key, func in pairs(keymap) do
    vim.keymap.set({ "n", "v", "x" }, key, func, { silent = true })
end


--------------------
-- Dial
--------------------

-- Load the plugin
local map = require("dial.map")

-- Description
local increment_desc = "Increment the number under the cursor"
local decrement_desc = "Decrement the number under the cursor"

-- Normal mode increment/decrement
vim.keymap.set(
    "n", "<C-a>", map.inc_normal(),
    opts(increment_desc)
)
vim.keymap.set(
    "n", "<C-x>", map.dec_normal(),
    opts(decrement_desc)
)

-- Visual mode increment/decrement
vim.keymap.set(
    "v", "<C-a>", map.inc_visual(),
    opts(increment_desc)
)
vim.keymap.set(
    "v", "<C-x>", map.dec_visual(),
    opts(decrement_desc)
)


--------------------
-- GitMessenger
--------------------

vim.keymap.set(
    "n", "G", ":GitMessenger<CR>",
    opts("Show git commit message")
)

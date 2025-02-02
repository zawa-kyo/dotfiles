--------------------
-- Utils
--------------------

-- Load utils
local utils = require("config.utils")

-- Rename variables for clarity
local opts = utils.getOpts
local keymap = vim.keymap.set

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

-- Check if the cursor is currently in a floating window (e.g., an LSP hover)
-- @return boolean
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

keymap("n", "<Esc>", close_window, opts("Close hover"))


--------------------
-- LSP
--------------------

keymap("n", "K", vim.lsp.buf.hover, opts("Show hover information"))
keymap("n", "gf", vim.lsp.buf.format, opts("Format the current file"))
keymap("n", "gr", vim.lsp.buf.references, opts("Show references"))
keymap("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
keymap("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
keymap("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
keymap("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
keymap("n", "rn", vim.lsp.buf.rename, opts("Rename the symbol"))
keymap("n", "ga", vim.lsp.buf.code_action, opts("Show available code actions"))
keymap("n", "ge", vim.diagnostic.open_float, opts("Show diagnostics"))
keymap("n", "g]", vim.diagnostic.goto_next, opts("Go to next diagnostic issue"))
keymap("n", "g[", vim.diagnostic.goto_prev, opts("Go to previous diagnostic issue"))


--------------------
-- Fern
--------------------

-- Load the plugin
local fern = require("plugins.fern")

-- Open file or expand directory when in Fern buffer
keymap("n", "<leader>b", fern.toggle_or_close_fern, opts("Toggle or close Fern"))

-- Toggle focus to Fern or reveal current file in Fern
keymap("n", "<leader>o", fern.toggle_fern_with_reveal, opts("Toggle or reveal in Fern"))


--------------------
-- Toggleterm
--------------------

-- Open a terminal in a horizontal split
keymap(
    "n", "<leader>t",
    ":ToggleTerm direction=horizontal name=desktop<CR>",
    opts("Open terminal in a horizontal split")
)


--------------------
-- Fzf
--------------------

-- Load the plugin
local fzf = require("plugins.fzf")

-- Trigger file search in the current directory
keymap(
    "n", "<leader>p", ":FzfLua files<CR>",
    opts("Search files in the current directory")
)

-- Perform a global search across all files
keymap(
    "n", "<leader>g", ":FzfLua live_grep<CR>",
    opts("Search text in all files")
)

-- Search within the current file (notify in fern buffer)
keymap(
    "n", "<leader>f", fzf.lines,
    opts("Search text in the current file")
)


--------------------
-- Neoscroll
--------------------

-- Load the plugin
local neoscroll = require("neoscroll")

local neoscroll_keymap_pairs = {
    ["<C-u>"]   = function() neoscroll.ctrl_u({ duration = 250 }) end,
    ["<C-d>"]   = function() neoscroll.ctrl_d({ duration = 250 }) end,
    ["<C-b>"]   = function() neoscroll.ctrl_b({ duration = 550 }) end,
    ["<C-f>"]   = function() neoscroll.ctrl_f({ duration = 550 }) end,
    ["<Tab>"]   = function() neoscroll.ctrl_d({ duration = 550 }) end,
    ["<S-Tab>"] = function() neoscroll.ctrl_u({ duration = 550 }) end,
}

for key, func in pairs(neoscroll_keymap_pairs) do
    keymap({ "n", "v", "x" }, key, func, opts("Scroll"))
end


--------------------
-- Dial
--------------------

-- Load the plugin
local map = require("dial.map")

-- Description
local increment_desc = "Increment the number under the cursor"
local decrement_desc = "Decrement the number under the cursor"

-- Increment/decrement
keymap("n", "<C-a>", map.inc_normal(), opts(increment_desc))
keymap("n", "<C-x>", map.dec_normal(), opts(decrement_desc))
keymap("v", "<C-a>", map.inc_visual(), opts(increment_desc))
keymap("v", "<C-x>", map.dec_visual(), opts(decrement_desc))


--------------------
-- GitMessenger
--------------------

local git_messenger = require("plugins.git-messenger")
keymap("n", "G", git_messenger.git_messenger_simple, opts("Show git commit message"))
keymap("n", "gc", git_messenger.git_messenger_with_diff, opts("Show git commit message with diff"))

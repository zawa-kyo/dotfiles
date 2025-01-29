--------------------
-- Typical Options
--------------------

-- Default options for keymaps
local opts = { noremap = true, silent = true }


--------------------
-- Utils
--------------------

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

vim.keymap.set("n", "<Esc>", close_window, opts)


--------------------
-- LSP
--------------------

vim.keymap.set('n', 'K', "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")


--------------------
-- Fern
--------------------

-- Load the plugin
local fern = require("plugins.fern")

-- Open file or expand directory when in Fern buffer
vim.keymap.set("n", "<leader>b", fern.toggle_or_close_fern, opts)

-- Toggle focus to Fern or reveal current file in Fern
vim.keymap.set("n", "<leader>o", fern.toggle_fern_with_reveal, opts)


--------------------
-- Toggleterm
--------------------

-- Open a terminal in a horizontal split
vim.keymap.set("n", "<leader>t", ":ToggleTerm direction=horizontal name=desktop<CR>", opts)


--------------------
-- Fzf
--------------------

-- Load the plugin
local fzf = require("plugins.fzf")

-- Trigger file search in the current directory
vim.keymap.set("n", "<leader>p", ":FzfLua files<CR>", opts)

-- Perform a global search across all files
vim.keymap.set("n", "<leader>g", ":FzfLua live_grep<CR>", opts)

-- Search within the current file (notify in fern buffer)
vim.keymap.set("n", "<leader>f", fzf.lines, opts)


--------------------
-- Dial
--------------------

-- Load the plugin
local map = require("dial.map")

-- Normal mode increment/decrement
vim.keymap.set("n", "<C-a>", map.inc_normal(), opts)
vim.keymap.set("n", "<C-x>", map.dec_normal(), opts)

-- Visual mode increment/decrement
vim.keymap.set("v", "<C-a>", map.inc_visual(), opts)
vim.keymap.set("v", "<C-x>", map.dec_visual(), opts)

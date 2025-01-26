--------------------
-- Typical Options
--------------------

local opts = { noremap = true, silent = true }


--------------------
-- Common Actions
--------------------

-- Function to handle <Esc> key behavior
-- Performs one action and skips subsequent ones
local function esc()
    -- Close floating window (hover)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end

    -- Disable highlighting
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
        return
    end
end

vim.keymap.set("n", "<Esc><Esc>", esc, opts)


--------------------
-- LSP
--------------------

vim.keymap.set('n', 'K', "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
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

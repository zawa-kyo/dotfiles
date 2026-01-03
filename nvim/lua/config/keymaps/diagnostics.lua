local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

--------------------
-- Diagnostics / Lists
--------------------

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

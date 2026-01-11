local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

------------------------
-- Diagnostics / Lists
------------------------

--- Check whether a quickfix window is currently open.
local function is_quickfix_open()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      return true
    end
  end

  return false
end

--- Check whether a location list window is currently open.
local function is_loclist_open()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      return true
    end
  end

  return false
end

--- Toggle the quickfix list window.
local function toggle_quickfix()
  if is_quickfix_open() then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

--- Toggle the location list window.
local function toggle_loclist()
  if is_loclist_open() then
    vim.cmd("lclose")
  else
    vim.cmd("lopen")
  end
end

-- Diagnostics
keymap("n", "]d", function()
  vim.diagnostic.goto_next({ float = false })
end, opts("Go to next diagnostic"))
keymap("n", "[d", function()
  vim.diagnostic.goto_prev({ float = false })
end, opts("Go to previous diagnostic"))

if not vim.g.vscode then
  keymap("n", "rd", vim.diagnostic.open_float, opts("Show diagnostic float"))
else
  utils.vscode_map("rd", "workbench.actions.view.problems", "Show Problems view (VSCode)")
end

-- Quickfix / Location List
keymap("n", "]q", "<Cmd>cnext<CR>", opts("Go to next quickfix item"))
keymap("n", "[q", "<Cmd>cprev<CR>", opts("Go to previous quickfix item"))
keymap("n", "rq", "<Cmd>copen<CR>", opts("Show quickfix list"))
keymap("n", "tq", toggle_quickfix, opts("Toggle quickfix list"))
keymap("n", "]l", "<Cmd>lnext<CR>", opts("Go to next location list item"))
keymap("n", "[l", "<Cmd>lprev<CR>", opts("Go to previous location list item"))
keymap("n", "rl", "<Cmd>lopen<CR>", opts("Show location list"))
keymap("n", "tl", toggle_loclist, opts("Toggle location list"))

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

--- Replace quickfix entries with a prompt for search/replace strings.
--- @param scope "file"|"entry" Controls whether to use cfdo (file) or cdo (entry).
local function replace_quickfix(scope)
  local old = vim.fn.input("Replace: ")
  if old == "" then
    vim.notify("Replace text is empty", vim.log.levels.WARN, { title = "Quickfix Replace" })
    return
  end

  local new = vim.fn.input("With: ")
  local escaped_old = vim.fn.escape(old, [[/\]])
  local escaped_new = vim.fn.escape(new, [[/\&]])

  if scope == "entry" then
    vim.cmd("cdo s/" .. escaped_old .. "/" .. escaped_new .. "/g | update")
    return
  end

  vim.cmd("cfdo %s/" .. escaped_old .. "/" .. escaped_new .. "/g | update")
end

--- Delete a quickfix entry by index (count) or current entry.
local function delete_quickfix_entry()
  local info = vim.fn.getqflist({ idx = 0, size = 0 })
  if not info or info.idx == 0 or info.size == 0 then
    vim.notify("Quickfix list is empty", vim.log.levels.WARN, { title = "Quickfix Delete" })
    return
  end

  local list = vim.fn.getqflist()
  local input = vim.fn.input("Select entry index to delete (empty = current): ")
  local target = tonumber(input) or info.idx
  if target > #list then
    vim.notify("Quickfix index is out of range", vim.log.levels.WARN, { title = "Quickfix Delete" })
    return
  end

  table.remove(list, target)
  local new_idx = #list == 0 and 0 or math.min(target, #list)
  vim.fn.setqflist(list, "r")
  if new_idx > 0 then
    vim.fn.setqflist({}, "a", { idx = new_idx })
  end

  vim.notify("Deleted quickfix entry: " .. target, vim.log.levels.INFO, { title = "Quickfix Delete" })
end

--- Clear all quickfix entries.
local function clear_quickfix()
  vim.cmd("cexpr []")
  vim.notify("Cleared quickfix list", vim.log.levels.INFO, { title = "Quickfix Delete" })
end

keymap("n", "mqr", function()
  replace_quickfix("entry")
end, opts("Replace all quickfix entries"))
keymap("n", "mqR", function()
  replace_quickfix("file")
end, opts("Replace all quickfix files"))

keymap("n", "mqd", delete_quickfix_entry, opts("Delete quickfix entry"))
keymap("n", "mqD", clear_quickfix, opts("Clear quickfix list"))

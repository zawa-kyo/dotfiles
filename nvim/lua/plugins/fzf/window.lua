local M = {}

local function is_snacks_picker(buf)
  local filetype = vim.bo[buf].filetype
  return filetype == "snacks_picker_list" or filetype == "snacks_picker_input"
end

-- Make sure future edits happen in a non-snacks picker window, splitting if needed
function M.ensure_edit_window()
  if not is_snacks_picker(0) then
    return
  end

  local current_win = vim.api.nvim_get_current_win()
  local windows = vim.api.nvim_tabpage_list_wins(0)

  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    if not is_snacks_picker(buf) then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.api.nvim_set_current_win(current_win)
  vim.cmd("vsplit")
  vim.cmd("enew")
end

-- Run the given action after guaranteeing we are in an edit-friendly window
function M.run_in_edit_window(action)
  M.ensure_edit_window()
  action()
end

function M.with_fzf(action)
  M.run_in_edit_window(function()
    action(require("fzf-lua"))
  end)
end

return M

local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

--------------------
-- Escape: Close helpers
--------------------

-- Close hover when cursor is in a hover window
local function close_hover_in_hover()
  local ok, noice = pcall(require, "noice")
  if ok and noice and noice.cmd then
    noice.cmd("dismiss")
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

-- Close windows matching a predicate
-- @param predicate fun(win: integer): boolean
-- @return boolean
local function close_windows(predicate)
  local closed = false

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and predicate(win) then
      pcall(vim.api.nvim_win_close, win, true)
      closed = true
    end
  end

  return closed
end

-- Check if a window is a floating window
-- @param win integer
-- @return boolean
local function is_floating_window(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

-- Check if a window is a Noice window
-- @param win integer
-- @return boolean
local function is_noice_window(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return vim.bo[buf].filetype == "noice"
end

-- Handle <Esc>: close hover or clear search highlight
local function close_window()
  local current_win = vim.api.nvim_get_current_win()

  if is_floating_window(current_win) then
    close_hover_in_hover()
    return
  end

  if close_windows(is_floating_window) then
    return
  end

  if close_windows(is_noice_window) then
    return
  end

  if vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
    return
  end
end

keymap("n", "<Esc>", close_window, opts("Close hover or clear search highlight"))

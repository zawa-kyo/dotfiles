local utils = require("config.utils")
local file_visibility = require("plugins.navigation.files.visibility")
local editor_windows = setmetatable({}, { __mode = "k" })

if vim.g.vscode then
  utils.vscode_map("te", "workbench.action.toggleSidebarVisibility", "Toggle Explorer (VSCode)")
  utils.vscode_map("re", "workbench.action.toggleSidebarVisibility", "Show Explorer (VSCode)")
end

-- Resize and position the main-window preview after Snacks initializes it.
local function configure_preview_window(picker)
  local preview = picker.preview.win
  preview.opts.width = 0.6
  preview.opts.height = 0.55
  preview.opts.row = nil
  preview.opts.col = 1
  preview.opts.border = "rounded"
  preview:update()
end

-- Return explorer options with preview rendered in the main editor window.
local function explorer_opts(on_show)
  return vim.tbl_deep_extend("force", file_visibility.navigation_opts(), {
    on_show = function(picker)
      configure_preview_window(picker)
      if on_show then
        on_show()
      end
    end,
    layout = {
      preset = "sidebar",
      preview = { enabled = true, main = true },
    },
  })
end

-- Toggle the Snacks explorer with shared navigation visibility.
local function toggle_explorer()
  require("snacks").explorer.open(explorer_opts())
end

-- Move focus between the explorer and the editor window it was entered from.
local function focus_explorer()
  local Snacks = require("snacks")
  local explorer = Snacks.picker.get({ source = "explorer" })[1]

  if explorer and explorer:is_focused() then
    local editor = editor_windows[explorer]
    if not (editor and vim.api.nvim_win_is_valid(editor)) then
      editor = explorer.main
    end
    if editor and vim.api.nvim_win_is_valid(editor) then
      vim.api.nvim_set_current_win(editor)
    end
    return
  end

  local editor = vim.api.nvim_get_current_win()
  if not explorer then
    explorer = Snacks.explorer.open(explorer_opts())
  else
    explorer:focus("list", { show = true })
  end
  editor_windows[explorer] = editor
end

-- Show the Snacks explorer and reveal the current file.
local function reveal_in_explorer()
  local Snacks = require("snacks")
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  local file = vim.api.nvim_buf_get_name(0)

  if not explorer then
    -- Reveal after the picker is attached to the current tab to avoid opening a duplicate.
    Snacks.explorer.open(explorer_opts(function()
      Snacks.explorer.reveal({ file = file })
    end))
    return
  end

  Snacks.explorer.reveal({ file = file })
end

return {
  "folke/snacks.nvim",
  cond = not vim.g.vscode,
  keys = {
    {
      "te",
      toggle_explorer,
      desc = "Toggle explorer",
    },
    {
      "ge",
      focus_explorer,
      desc = "Go to explorer or editor",
    },
    {
      "re",
      reveal_in_explorer,
      desc = "Show or reveal in explorer",
    },
  },
}

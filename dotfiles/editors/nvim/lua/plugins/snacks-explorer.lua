local utils = require("config.utils")
local file_visibility = require("config.file-visibility")

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
local function explorer_opts()
  return vim.tbl_deep_extend("force", file_visibility.navigation_opts(), {
    on_show = configure_preview_window,
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

-- Show the Snacks explorer and reveal the current file.
local function reveal_in_explorer()
  local Snacks = require("snacks")
  local explorer = Snacks.picker.get({ source = "explorer" })[1]

  if not explorer then
    Snacks.explorer.open(explorer_opts())
  end

  Snacks.explorer.reveal()
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
      "re",
      reveal_in_explorer,
      desc = "Show or reveal in explorer",
    },
  },
  opts = {
    explorer = {
      replace_netrw = false,
      trash = true,
    },
  },
}

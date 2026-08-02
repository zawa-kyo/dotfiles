local utils = require("config.utils")
local file_visibility = require("config.file-visibility")

if vim.g.vscode then
  utils.vscode_map("te", "workbench.action.toggleSidebarVisibility", "Toggle Explorer (VSCode)")
  utils.vscode_map("re", "workbench.action.toggleSidebarVisibility", "Show Explorer (VSCode)")
end

-- Toggle the Snacks explorer with shared navigation visibility.
local function toggle_explorer()
  require("snacks").explorer.open(file_visibility.navigation_opts())
end

-- Show the Snacks explorer and reveal the current file.
local function reveal_in_explorer()
  local Snacks = require("snacks")
  local explorer = Snacks.picker.get({ source = "explorer" })[1]

  if not explorer then
    Snacks.explorer.open(file_visibility.navigation_opts())
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

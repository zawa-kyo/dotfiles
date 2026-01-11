local utils = require("config.utils")

if not vim.g.vscode then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

if vim.g.vscode then
  utils.vscode_map("te", "workbench.action.toggleSidebarVisibility", "Toggle Explorer (VSCode)")
  utils.vscode_map("re", "workbench.action.toggleSidebarVisibility", "Show Explorer (VSCode)")
end

local function toggle_explorer(reveal)
  local Snacks = require("snacks")
  local pickers = Snacks.picker.get({ source = "explorer" })
  local picker = pickers and pickers[1]

  if picker and not picker.closed then
    picker:close()
    return
  end

  if reveal then
    Snacks.explorer.reveal()
    return
  end

  Snacks.explorer.open()
end

return {
  "folke/snacks.nvim",
  cond = not vim.g.vscode,
  keys = {
    {
      "te",
      function()
        toggle_explorer(false)
      end,
      desc = "Toggle explorer",
    },
    {
      "re",
      function()
        toggle_explorer(true)
      end,
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

local picker_keymaps = require("plugins.picker.keymaps")

if vim.g.vscode then
  picker_keymaps.vscode()
end

return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  opts = {
    picker = require("plugins.picker.config"),
  },
  keys = picker_keymaps.keys,
}

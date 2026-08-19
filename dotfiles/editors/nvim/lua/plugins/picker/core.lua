local picker_keymaps = require("plugins.picker.keymaps")

if vim.g.vscode then
  picker_keymaps.vscode()
end

return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  keys = picker_keymaps.keys,
}

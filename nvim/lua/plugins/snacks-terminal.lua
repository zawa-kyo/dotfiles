local utils = require("config.utils")

if vim.g.vscode then
  utils.vscode_map("tt", "workbench.action.terminal.toggleTerminal", "Toggle terminal (VSCode)")
end

return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  keys = {
    {
      "tt",
      function()
        require("snacks").terminal(nil, {
          win = {
            position = "float",
            border = "rounded",
          },
        })
      end,
      mode = { "n", "t" },
      desc = "Toggle terminal",
    },
  },

  opts = {
    terminal = {
      win = {
        style = "terminal",
        position = "float",
        backdrop = 60,
        height = 0.9,
        width = 0.9,
      },
    },
  },
}

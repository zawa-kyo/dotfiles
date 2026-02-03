local utils = require("config.utils")

if vim.g.vscode then
  utils.vscode_map("tt", "workbench.action.terminal.toggleTerminal", "Toggle terminal (VSCode)")
end

---Toggle the Snacks floating terminal window.
local function toggle_terminal()
  require("snacks").terminal(nil, {
    win = {
      position = "float",
      border = "rounded",
    },
  })
end

return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  keys = {
    {
      "tt",
      toggle_terminal,
      mode = "n",
      desc = "Toggle terminal",
    },
    {
      "tT",
      toggle_terminal,
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

return {
  "mvllow/modes.nvim",

  event = "VeryLazy",
  cond = not vim.g.vscode,

  opts = {
    set_number = true,
    set_cursorline = true,
    line_opacity = 0.3,

    -- Adjust the palette later to match the chosen colorscheme
    modes = {
      copy = {
        color = "#f5c359",
      },
      delete = {
        color = "#c75c6a",
      },
      insert = {
        color = "#4db5bd",
      },
      visual = {
        color = "#769ff0",
      },
    },
  },
}

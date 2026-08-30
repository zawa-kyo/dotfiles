local mini_files = require("plugins.navigation.mini-files.config")

return {
  "echasnovski/mini.files",
  cond = not vim.g.vscode,

  keys = {
    {
      "-",
      mini_files.open_project_reveal,
      desc = "Show mini.files (project root, reveal file)",
    },
    {
      "_",
      mini_files.open_project_root,
      desc = "Show mini.files (project root)",
    },
  },
  config = mini_files.setup,
}

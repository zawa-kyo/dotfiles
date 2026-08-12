local mini_files = require("config.mini-files")

return {
  "echasnovski/mini.files",
  cond = not vim.g.vscode,
  dependencies = {
    {
      "ahmedkhalf/project.nvim",
      config = function()
        -- Provide consistent project roots for mini.files navigation.
        require("project_nvim").setup({
          -- Avoid LSP-based root detection to prevent deprecated API usage
          detection_methods = { "pattern" },
          patterns = { ".git", "Makefile", "package.json" },
        })
      end,
    },
  },

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

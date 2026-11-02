local preview = require("plugins.documents.render-markdown.preview")

return {
  "delphinus/md-render.nvim",
  version = "*",
  ft = { "markdown", "markdown.mdx" },
  cmd = { "MdRender" },
  cond = not vim.g.vscode,

  dependencies = {
    "DaikyXendo/nvim-material-icon",
    "delphinus/budoux.lua",
  },

  init = preview.setup,

  keys = {
    {
      "tmp",
      preview.toggle_split_preview,
      desc = "Toggle Markdown split preview",
    },
    {
      "tmr",
      function()
        vim.cmd("MdRender toggle")
      end,
      desc = "Toggle Markdown rendering in the current window",
    },
  },
}

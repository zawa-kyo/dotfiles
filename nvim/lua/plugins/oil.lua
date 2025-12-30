return {
  "stevearc/oil.nvim",
  cond = not vim.g.vscode,

  dependencies = {
    "DaikyXendo/nvim-material-icon",
    opts = {},
  },

  keys = {
    {
      "-",
      "<CMD>Oil<CR>",
      desc = "Open Oil",
    },
  },
  config = function()
    require("oil").setup({
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
    })
  end,
}

return {
  "mawkler/modicator.nvim",

  cond = not vim.g.vscode,
  event = "VeryLazy",

  dependencies = {
    "nvim-lualine/lualine.nvim",
  },

  opts = {
    integration = {
      lualine = {
        enabled = true,
        mode_section = "a",
      },
    },
  },
}

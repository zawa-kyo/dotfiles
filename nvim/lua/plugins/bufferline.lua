return {
  "akinsho/bufferline.nvim",

  lazy = false,
  cond = not vim.g.vscode,
  dependencies = "DaikyXendo/nvim-material-icon",

  -- TODO: Customize the bufferline appearance.
  opts = {
    options = {
      mode = "buffers",
      always_show_bufferline = true,
      show_close_icon = false,
      show_buffer_close_icons = false,
      show_tab_indicators = false,
    },
  },
}

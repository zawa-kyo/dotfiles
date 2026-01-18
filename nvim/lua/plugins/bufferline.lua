return {
  "akinsho/bufferline.nvim",

  lazy = false,
  cond = not vim.g.vscode,
  dependencies = "DaikyXendo/nvim-material-icon",

  keys = {
    {
      "tB",
      function()
        vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
      end,
      desc = "Toggle bufferline",
    },
  },

  opts = {
    options = {
      mode = "buffers",
      always_show_bufferline = true,
      separator_style = "thin",
      right_mouse_command = function() end,
      middle_mouse_command = function() end,
      tab_size = 8,
      minimum_padding = 0,
      show_close_icon = false,
      show_buffer_close_icons = false,
      show_tab_indicators = false,
    },
    highlights = {
      buffer_selected = {
        italic = false,
      },
    },
  },
}

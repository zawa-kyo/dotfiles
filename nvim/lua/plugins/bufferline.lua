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
      -- Show buffer tabs instead of tab pages.
      mode = "buffers",
      -- Keep the bufferline visible even with a single buffer.
      always_show_bufferline = true,
      -- Use thin separators between buffer tabs.
      separator_style = "thin",
      -- Disable right-click buffer closing; use explicit close actions instead.
      right_mouse_command = function() end,
      -- Disable middle-click buffer closing to avoid accidental closes.
      middle_mouse_command = function() end,
      -- Keep a compact minimum width for each tab.
      tab_size = 8,
      -- Remove extra padding around tab labels.
      minimum_padding = 0,
      -- Hide the global close icon.
      show_close_icon = false,
      -- Hide per-buffer close icons.
      show_buffer_close_icons = false,
      -- Hide tab page indicators on the right.
      show_tab_indicators = false,
    },
    highlights = {
      buffer_selected = {
        italic = false,
      },
    },
  },
}

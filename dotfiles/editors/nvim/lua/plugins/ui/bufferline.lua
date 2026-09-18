return {
  "akinsho/bufferline.nvim",

  cond = not vim.g.vscode,
  dependencies = "DaikyXendo/nvim-material-icon",
  event = "UIEnter",

  keys = {
    {
      "tB",
      function()
        vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
      end,
      desc = "Toggle tab line",
    },
  },

  opts = {
    options = {
      -- Display tab pages while preserving the compact tabline appearance.
      mode = "tabs",
      always_show_bufferline = true,
      separator_style = "thin",
      -- Prevent mouse clicks from closing tab pages accidentally.
      right_mouse_command = function() end,
      middle_mouse_command = function() end,
      tab_size = 8,
      minimum_padding = 0,
      show_close_icon = false,
      show_buffer_close_icons = false,
      show_tab_indicators = false,
      name_formatter = function(tab)
        local name = tab.name or ""
        if name == "" then
          return "[No Name]"
        end

        return vim.fn.fnamemodify(name, ":t:r")
      end,
    },
  },
}

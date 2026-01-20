return {
  {
    "gen740/SmoothCursor.nvim",

    cond = not vim.g.vscode,
    event = { "CursorMoved", "CursorMovedI" },

    config = function()
      require("smoothcursor").setup({
        fancy = {
          enable = true,
          head = { cursor = "", linehl = nil },
          body = {
            { cursor = "󰝥", texthl = "SmoothCursorRed" },
            { cursor = "󰝥", texthl = "SmoothCursorOrange" },
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" },
        },
        autostart = true,
        always_redraw = true,
        flyin_effect = "top",
        speed = 25,
        intervals = 35,
        priority = 13,
        timeout = 3000,
        threshold = 3,
        disable_float_win = true,
        enabled_filetypes = nil,
        show_last_positions = nil,
      })

      vim.cmd("highlight SmoothCursor guifg=#a6e3a1")
      vim.cmd("highlight SmoothCursorRed guifg=#f38ba8")
      vim.cmd("highlight SmoothCursorOrange guifg=#fab387")
      vim.cmd("highlight SmoothCursorYellow guifg=#f9e2af")
      vim.cmd("highlight SmoothCursorGreen guifg=#a6e3a1")
      vim.cmd("highlight SmoothCursorAqua guifg=#89dceb")
      vim.cmd("highlight SmoothCursorBlue guifg=#89b4fa")
      vim.cmd("highlight SmoothCursorPurple guifg=#cba6f7")
    end,
  },
}

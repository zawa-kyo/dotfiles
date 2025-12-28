return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "m",
      mode = "n",
      desc = "Flash Word (HopWord-like)",
      function()
        require("flash").jump({
          search = { multi_window = false },
          matcher = function(win)
            local matches = {}
            local buf = vim.api.nvim_win_get_buf(win)
            local l0 = vim.fn.line("w0", win)
            local l1 = vim.fn.line("w$", win)

            for lnum = l0, l1 do
              local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
              local col = 0
              while true do
                local s, e = line:find("[%w_]+", col + 1)
                if not s or not e then
                  break
                end
                table.insert(matches, {
                  win = win,
                  pos = { lnum, s - 1 },
                  end_pos = { lnum, e - 1 },
                })
                col = e
              end
            end
            return matches
          end,
        })
      end,
    },

    {
      "M",
      mode = "n",
      desc = "Flash Line (HopLine-like)",
      function()
        require("flash").jump({
          search = { multi_window = false },
          matcher = function(win)
            local matches = {}
            local l0 = vim.fn.line("w0", win)
            local l1 = vim.fn.line("w$", win)
            for lnum = l0, l1 do
              table.insert(matches, {
                win = win,
                pos = { lnum, 0 },
                end_pos = { lnum, 0 },
              })
            end
            return matches
          end,
        })
      end,
    },
  },
}

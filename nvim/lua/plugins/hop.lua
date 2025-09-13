return {
  "smoka7/hop.nvim",

  lazy = true,
  event = {
    "BufRead",
    "BufNewFile",
  },

  opts = {
    multi_windows = true,
  },

  keys = {
    -- Jump to a word
    {
      "m",
      "<cmd>HopWord<CR>",
      mode = "n",
      desc = "Hop Word",
    },

    -- Jump to a line
    {
      "M",
      "<cmd>HopLine<CR>",
      mode = "n",
      desc = "Hop Line",
    },

    -- Jump to a character in the current line (after the cursor)
    {
      "f",
      "<cmd>HopChar1CurrentLineAC<CR>",
      mode = { "n", "v", "o" },
      desc = "Hop Char (after cursor)",
    },

    -- Jump to a character in the current line (before the cursor)
    {
      "F",
      "<cmd>HopChar1CurrentLineBC<CR>",
      mode = { "n", "v", "o" },
      desc = "Hop Char (before cursor)",
    },

    -- Jump to just before a character in the current line (after the cursor)
    {
      "t",
      function()
        local hop = require("hop")
        local hint = require("hop.hint")
        hop.hint_char1({
          direction = hint.HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end,
      mode = { "n", "v", "o" },
      desc = "Hop before char (after cursor)",
    },

    -- Jump to just after a character in the current line (before the cursor)
    {
      "T",
      function()
        local hop = require("hop")
        local hint = require("hop.hint")
        hop.hint_char1({
          direction = hint.HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end,
      mode = { "n", "v", "o" },
      desc = "Hop after char (before cursor)",
    },
  },
}

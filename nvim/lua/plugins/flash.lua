return {
  "folke/flash.nvim",

  event = "VeryLazy",

  opts = {
    jump = {
      jumplist = true,
    },
    modes = {
      search = {
        enabled = true,
      },
      char = {
        jump_labels = true,
        keys = { "f", "F", "t", "T", "n", "N", ";", "," },
        char_actions = function(motion)
          return {
            ["n"] = "next",
            ["N"] = "prev",
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
      },
    },
  },

  keys = {
    {
      "?",
      mode = "n",
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash search with treesitter",
    },
    {
      "gl", -- go line
      mode = "n",
      function()
        require("flash").jump({
          search = {
            mode = "search",
            max_length = 0,
            multi_window = false,
          },
          pattern = [[^]],
          label = { before = true, after = false },
        })
      end,
      desc = "Flash line jump",
    },
    {
      "r", -- remote
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Flash remote jump",
    },
  },
}

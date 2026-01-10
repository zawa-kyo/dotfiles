return {
  "folke/flash.nvim",

  event = "VeryLazy",

  opts = {
    modes = {
      char = {
        jump_labels = true,
        keys = { "f", "F", "t", "T", "n", "N" },
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
      "m",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash jump",
    },
    {
      "M",
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
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Flash remote jump",
    },
  },
}

return {
  "folke/flash.nvim",
  event = "VeryLazy",

  keys = {
    {
      "m",
      mode = "n",
      desc = "Flash Word (HopWord-like)",
      function()
        require("flash").jump({
          search = {
            mode = "search",
            max_length = 0,
            multi_window = false,
          },
          pattern = [[\<\k]],
          label = { before = true, after = false },
        })
      end,
    },

    {
      "M",
      mode = "n",
      desc = "Flash Line (HopLine-like)",
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
    },
  },
}

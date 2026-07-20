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
        keys = { "f", "F", "t", "T", "n", "p", "N", ";", "," },
        char_actions = function(motion)
          return {
            ["n"] = "next",
            ["p"] = "prev",
            ["N"] = "prev",
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
      },
    },
  },

  config = function(_, opts)
    require("flash").setup(opts)

    local search = require("flash.plugins.search")
    local jump = search.jump
    search.jump = function(match, state)
      -- flash.nvim detects search labels by letting the typed label briefly extend
      -- the active / or ? command-line pattern. With Noice and native search
      -- message handling, that transient pattern can be reported as a real failed
      -- search, e.g. `/stringk` after pressing the `k` label for `/string`.
      --
      -- Keep the upstream jump behavior intact, but restore the command-line text
      -- to the real search pattern before leaving search mode. This keeps the
      -- consumed label out of search history, search messages, and E486 reports.
      local cmdtype = vim.fn.getcmdtype()
      if not search.op and (cmdtype == "/" or cmdtype == "?") then
        vim.fn.setcmdline(state.pattern())
      end
      jump(match, state)
    end
  end,

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

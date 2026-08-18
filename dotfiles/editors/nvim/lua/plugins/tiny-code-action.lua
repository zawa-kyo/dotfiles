return {
  "rachartier/tiny-code-action.nvim",

  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "folke/snacks.nvim" },
  },

  opts = {
    picker = {
      "snacks",
      opts = {},
    },
  },

  keys = {
    {
      "mc",
      function()
        require("tiny-code-action").code_action({})
      end,
      mode = { "n", "v" },
      desc = "Code Actions",
    },
  },
}

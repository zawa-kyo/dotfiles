return {
  "folke/which-key.nvim",

  event = "VeryLazy",
  cond = not vim.g.vscode,
  opts = {},

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Declare a normal-mode prefix group so "s" shows search-related mappings.
    wk.add({
      { "s", group = "search" },
    })
  end,

  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

return {
  "folke/which-key.nvim",

  event = "VeryLazy",
  cond = not vim.g.vscode,
  opts = {},

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Declare a normal-mode prefix group so "s" shows symbol-related mappings.
    wk.add({
      { "s", group = "symbols" },
    })
  end,

  keys = {
    {
      "s",
      "<Cmd>WhichKey s<CR>",
      desc = "Symbols prefix",
      nowait = true,
    },
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

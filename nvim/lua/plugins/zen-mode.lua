return {
  {
    "folke/zen-mode.nvim",

    -- TODO: Notify when zen mode is toggled.
    keys = {
      { "tz", "<Cmd>ZenMode<CR>", desc = "Toggle zen mode" },
    },

    config = function()
      require("zen-mode").setup({})
    end,
  },
}

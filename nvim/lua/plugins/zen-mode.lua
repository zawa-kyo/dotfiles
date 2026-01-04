return {
  {
    "folke/zen-mode.nvim",

    keys = {
      { "<leader>z", "<Cmd>ZenMode<CR>", desc = "Toggle zen mode" },
    },

    config = function()
      require("zen-mode").setup({})
    end,
  },
}

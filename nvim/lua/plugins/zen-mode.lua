return {
  {
    "folke/zen-mode.nvim",

    keys = {
      { "tz", "<Cmd>ZenMode<CR>", desc = "Toggle zen mode" },
    },

    config = function()
      require("zen-mode").setup({
        on_open = function()
          vim.notify("Zen mode enabled")
        end,
        on_close = function()
          vim.notify("Zen mode disabled")
        end,
      })
    end,
  },
}

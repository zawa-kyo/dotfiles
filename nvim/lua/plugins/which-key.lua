return {
  "folke/which-key.nvim",

  opts = {
    preset = "helix",

    spec = {
      { "g", group = "Go" },
      { "s", group = "Search" },
      { "t", group = "Toggle" },
      { "m", group = "Modify" },
      { "r", group = "Reveal" },
      { "X", group = "Execute" },
      { "[", group = "Cycle Prev" },
      { "]", group = "Cycle Next" },
      { "z", group = "View" },
      { "<leader>", group = "Leader" },
    },
  },

  keys = {
    {
      "<leader>?",
      function()
        vim.cmd("WhichKey")
      end,
      desc = "Show buffer keymaps",
    },
  },
}

return {
  "roodolv/markdown-toggle.nvim",

  ft = { "markdown", "markdown.mdx" },

  config = function()
    require("markdown-toggle").setup({
      use_default_keymaps = false,
    })
  end,

  keys = {
    {
      "tmc",
      function()
        require("markdown-toggle").checkbox()
      end,
      mode = { "n", "x" },
      desc = "Toggle checkbox",
    },
    {
      "tml",
      function()
        require("markdown-toggle").list()
      end,
      mode = { "n", "x" },
      desc = "Toggle list",
    },
    {
      "mmc",
      function()
        require("markdown-toggle").checkbox_cycle()
      end,
      mode = { "n", "x" },
      desc = "Toggle checkbox cycle",
    },
  },
}

return {
  "roodolv/markdown-toggle.nvim",

  ft = { "markdown", "markdown.mdx" },

  config = function()
    require("markdown-toggle").setup({
      use_default_keymaps = false,
      keymaps = {
        toggle = {
          tmc = "checkbox",
          tml = "list",
          mmc = "checkbox_cycle",
        },
      },
    })
  end,
}

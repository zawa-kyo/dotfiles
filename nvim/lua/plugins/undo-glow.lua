return {
  "y3owk1n/undo-glow.nvim",

  cond = not vim.g.vscode,
  event = "VeryLazy",

  config = function()
    require("undo-glow").setup({
      animation = {
        enabled = true,
        duration = 300,
      },
    })
  end,
}

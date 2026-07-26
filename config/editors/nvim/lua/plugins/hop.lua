return {
  "smoka7/hop.nvim",

  cond = not vim.g.vscode,
  keys = {
    { "gl", "<Cmd>HopLine<CR>", desc = "Hop to line" },
  },

  config = function()
    require("hop").setup()
  end,
}

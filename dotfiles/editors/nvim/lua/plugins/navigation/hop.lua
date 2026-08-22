return {
  "smoka7/hop.nvim",

  cond = not vim.g.vscode,
  keys = {
    { "gl", "<Cmd>HopLine<CR>", desc = "Hop to line" },
    { "J", "<Cmd>HopWord<CR>", desc = "Hop to word" },
  },

  config = function()
    require("hop").setup()
  end,
}

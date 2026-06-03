return {
  "smoka7/hop.nvim",

  cond = not vim.g.vscode,
  keys = {
    { "J", "<Cmd>HopWord<CR>", desc = "Hop to word" },
  },

  config = function()
    require("hop").setup()
  end,
}

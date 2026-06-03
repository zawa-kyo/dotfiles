return {
  "folke/todo-comments.nvim",

  cond = not vim.g.vscode,
  event = { "BufRead", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    require("todo-comments").setup()
  end,
}

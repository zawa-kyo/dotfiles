return {
  "folke/todo-comments.nvim",

  cond = not vim.g.vscode,
  event = { "BufRead", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    {
      "sT",
      function()
        require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Search todo comments (Todo/Fix/Fixme)",
    },
  },

  config = function()
    require("todo-comments").setup()
  end,
}

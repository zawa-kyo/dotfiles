-- Search the project TODO comments that need follow-up.
local function search_todo_comments()
  require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end

return {
  "folke/todo-comments.nvim",

  cond = not vim.g.vscode,
  event = { "BufRead", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    {
      "sT",
      search_todo_comments,
      desc = "Search todo comments (Todo/Fix/Fixme)",
    },
  },

  config = function()
    require("todo-comments").setup()
  end,
}

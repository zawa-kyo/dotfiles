-- Format TODO search results without Tree-sitter highlighting.
local function format_todo_comment(item, picker)
  local align = Snacks.picker.util.align
  local _, _, keyword = require("todo-comments.highlight").match(item.text)
  local result = {}

  if keyword then
    keyword = require("todo-comments.config").keywords[keyword] or keyword
    local icon = vim.tbl_get(require("todo-comments.config").options.keywords, keyword, "icon") or ""
    result[#result + 1] = { align(icon, 2), "TodoFg" .. keyword }
    result[#result + 1] = { align(keyword, 6, { align = "center" }), "TodoBg" .. keyword }
    result[#result + 1] = { " " }
  end

  vim.list_extend(result, Snacks.picker.format.filename(item, picker))

  if item.line then
    result[#result + 1] = { "  " }
    result[#result + 1] = { item.line }
  end

  return result
end

-- Search the project TODO comments that need follow-up.
local function search_todo_comments()
  local snacks = require("snacks")
  snacks.picker.sources.todo_comments = snacks.picker.sources.todo_comments or require("todo-comments.snacks").source
  snacks.picker.pick("todo_comments", {
    keywords = { "TODO", "FIX", "FIXME" },
    format = format_todo_comment,
  })
end

return {
  "folke/todo-comments.nvim",

  cond = not vim.g.vscode,
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },

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

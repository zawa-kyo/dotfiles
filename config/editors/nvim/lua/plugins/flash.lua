-- Start structural search over Tree-sitter ranges.
local function treesitter_search()
  require("flash").treesitter_search()
end

return {
  "folke/flash.nvim",

  cond = not vim.g.vscode,

  keys = {
    {
      "?",
      treesitter_search,
      mode = "n",
      desc = "Search with Tree-sitter ranges",
    },
  },

  opts = {
    modes = {
      char = { enabled = false },
      search = { enabled = false },
      treesitter_search = {
        search = { multi_window = false },
      },
    },
  },
}

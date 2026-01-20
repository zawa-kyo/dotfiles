return {
  "shellRaining/hlchunk.nvim",

  lazy = true,
  event = {
    "BufRead",
    "BufNewFile",
  },
  cond = not vim.g.vscode,

  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        use_treesitter = true,
        duration = 250,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        style = "#ea7183",
        textobject = "ic",
      },
    })
  end,
}

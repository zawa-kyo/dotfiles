return {
  "vim-jp/vimdoc-ja",

  lazy = true,
  keys = {
    { "h", mode = "c" },
  },
  cond = not vim.g.vscode,
}

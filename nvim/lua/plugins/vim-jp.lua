return {
    "vim-jp/vimdoc-ja",
    lazy = true,
    keys = {
        { "h", mode = "c", },
    },
    cnd = not vim.g.vscode,
}

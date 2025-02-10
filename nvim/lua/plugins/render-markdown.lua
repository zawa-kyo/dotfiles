return {
    "MeanderingProgrammer/render-markdown.nvim",
    cnd = not vim.g.vscode,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    ft = { "markdown" },
}

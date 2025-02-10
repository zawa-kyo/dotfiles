return {
    "MeanderingProgrammer/render-markdown.nvim",

    lazy = true,
    ft = { "markdown" },
    cnd = not vim.g.vscode,

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
}

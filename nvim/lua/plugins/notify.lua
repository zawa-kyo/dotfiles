return {
    "rcarriga/nvim-notify",

    cond = not vim.g.vscode,

    config = function()
        require("notify").setup({
            background_colour = "#000000",
        })
        vim.notify = require("notify")
    end,
}

local M = {
    "karb94/neoscroll.nvim",

    lazy = false,
    cnd = not vim.g.vscode,

    config = function()
        require("neoscroll").setup({ easing = "sine" })
    end,
}

return M

local M = {
    "karb94/neoscroll.nvim",
    lazy = false,
    config = function()
        require("neoscroll").setup({ easing = "sine" })
    end,
}

return M

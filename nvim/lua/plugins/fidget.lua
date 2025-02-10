return {
    "j-hui/fidget.nvim",

    lazy = true,
    event = {
        "BufReadPre",
        "BufNewFile",
    },

    config = function()
        require("fidget").setup({
            notification = {
                window = {
                    -- Background color opacity
                    winblend = 0,
                }
            }
        })
    end,
}

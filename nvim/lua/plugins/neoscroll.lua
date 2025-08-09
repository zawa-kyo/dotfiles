local M = {
    "karb94/neoscroll.nvim",

    lazy = false,
    cond = not vim.g.vscode,


    keys = (function()
        local n = require('neoscroll')
        return {
            {"<C-u>", function() n.ctrl_u({ duration = 250 }) end, mode = {"n","v","x"}, desc = "Scroll up"},
            {"<C-d>", function() n.ctrl_d({ duration = 250 }) end, mode = {"n","v","x"}, desc = "Scroll down"},
            {"<C-b>", function() n.ctrl_b({ duration = 550 }) end, mode = {"n","v","x"}, desc = "Page up"},
            {"<C-f>", function() n.ctrl_f({ duration = 550 }) end, mode = {"n","v","x"}, desc = "Page down"},
            {"<Tab>", function() n.ctrl_d({ duration = 550 }) end, mode = {"n","v","x"}, desc = "Scroll down"},
            {"<S-Tab>", function() n.ctrl_u({ duration = 550 }) end, mode = {"n","v","x"}, desc = "Scroll up"},
        }
    end)(),


    config = function()
        require("neoscroll").setup({ easing = "sine" })
    end,
}

return M

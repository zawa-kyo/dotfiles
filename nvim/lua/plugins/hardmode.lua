return {
    dir = "./local-plugins",

    config = function()
        local hardmode = require("local-plugins.hardmode")

        vim.api.nvim_create_user_command("HardMode", hardmode.hard_mode, {})
        vim.api.nvim_create_user_command("EasyMode", hardmode.easy_mode, {})
    end,
}

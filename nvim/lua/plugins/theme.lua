return {
    'shaunsingh/nord.nvim',

    lazy = false,
    priority = 1000,
    cond = not vim.g.vscode,

    config = function()
        vim.g.nord_contrast = true
        vim.g.nord_borders = false
        vim.g.nord_disable_background = true
        vim.g.nord_italic = false
        vim.g.nord_uniform_diff_background = true
        vim.g.nord_bold = false

        -- Enable popup menu transparency with 0% opacity
        vim.opt.pumblend = 0

        -- Apply colorscheme here to ensure it runs after lazy loads the theme
        vim.cmd("colorscheme nord")
    end,
}

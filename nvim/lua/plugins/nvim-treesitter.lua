return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {
            "lua",
            "typescript",
            "javascript"
        },
        sync_install = true,
        indent = {
            enable = true
        }
    }
}

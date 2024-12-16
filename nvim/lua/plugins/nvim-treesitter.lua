return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installe = {
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

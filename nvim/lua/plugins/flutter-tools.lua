return {
    "nvim-flutter/flutter-tools.nvim",

    -- Only load on dart files
    lazy = true,
    ft = { "dart" },

    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
    },

    config = true,
}

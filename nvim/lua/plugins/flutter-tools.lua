return {
    "nvim-flutter/flutter-tools.nvim",

    -- only load on dart files
    lazy = true,
    ft = { "dart" },

    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
    },
    config = true,
}

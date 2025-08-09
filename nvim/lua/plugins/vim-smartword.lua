return {
    "kana/vim-smartword",

    lazy = true,
    keys = {
        {
            "w",
            "<Plug>(smartword-w)",
            desc = "Move to the next word",
            mode = "n",
            remap = true
        },
        {
            "b",
            "<Plug>(smartword-b)",
            desc = "Move to the previous word",
            mode = "n",
            remap = true
        },
        {
            "e",
            "<Plug>(smartword-e)",
            desc = "Move to the end of the word",
            mode = "n",
            remap = true
        },
    },

    event = {
        "BufRead",
        "BufNewFile",
    },
}

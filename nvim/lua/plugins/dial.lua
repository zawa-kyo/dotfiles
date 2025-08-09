local M = {
    "monaqa/dial.nvim",

    lazy = true,
    event = {
        "BufRead",
        "BufNewFile",
    },

    keys = {
        {"<C-a>", function() require("dial.map").inc_normal()() end, desc = "Increment the number under the cursor", mode = "n"},
        {"<C-x>", function() require("dial.map").dec_normal()() end, desc = "Decrement the number under the cursor", mode = "n"},
        {"<C-a>", function() require("dial.map").inc_visual()() end, desc = "Increment the number under the cursor", mode = "v"},
        {"<C-x>", function() require("dial.map").dec_visual()() end, desc = "Decrement the number under the cursor", mode = "v"},
    },
}

function M.config()
    local dial = require("dial.config")
    local augend = require("dial.augend")

    dial.augends:register_group({
        default = {
            augend.integer.alias.decimal,  -- integer: decimal
            augend.integer.alias.hex,      -- integer: hex
            augend.date.alias["%Y/%m/%d"], -- date: YYYY/MM/DD
            augend.constant.alias.bool,    -- true/false toggle
        },
    })
end

return M

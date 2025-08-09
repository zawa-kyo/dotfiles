local M = {
    "monaqa/dial.nvim",

    lazy = true,
    event = {
        "BufRead",
        "BufNewFile",
    },

    keys = (function()
        local map = require("dial.map")
        return {
            {"<C-a>", map.inc_normal(), desc = "Increment the number under the cursor", mode = "n"},
            {"<C-x>", map.dec_normal(), desc = "Decrement the number under the cursor", mode = "n"},
            {"<C-a>", map.inc_visual(), desc = "Increment the number under the cursor", mode = "v"},
            {"<C-x>", map.dec_visual(), desc = "Decrement the number under the cursor", mode = "v"},
        }
    end)(),
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

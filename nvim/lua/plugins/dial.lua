local M = {
    "monaqa/dial.nvim",

    lazy = true,
    event = {
        "BufRead",
        "BufNewFile",
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

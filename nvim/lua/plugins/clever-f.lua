return {
    "rhysd/clever-f.vim",
    config = function()
        -- Highlight the next search target
        vim.g.clever_f_mark_char = true

        -- Enable smart case for search
        vim.g.clever_f_smart_case = true

        -- Disable ignore case
        vim.g.clever_f_ignore_case = false
    end
}

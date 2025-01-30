-- Module for utility functions
M = {}

--- Get options with a description
--- @param desc string|nil Description of the mapping
--- @return table opts A table containing keymap options
function M.getOpts(desc)
    -- Clone opts() to avoid modifying the original table
    local options = { noremap = true, silent = true }

    if desc then
        options.desc = desc
    end
    return options
end

return M

M = {}

-- Get options with a description
function M.getOpts(desc)
    -- Clone opts() to avoid modifying the original table
    local options = { noremap = true, silent = true }

    if desc then
        options.desc = desc
    end
    return options
end

return M

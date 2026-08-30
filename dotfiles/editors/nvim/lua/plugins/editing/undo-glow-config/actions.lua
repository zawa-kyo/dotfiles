---@alias UndoGlowAction fun()
---@class UndoGlowActions
local M = {}

local search_options = {
  animation = {
    animation_type = "strobe",
  },
}

--- Move to the next search match with glow and highlight lenses.
---@type UndoGlowAction
function M.search_next()
  require("undo-glow").search_next(search_options)
  require("hlslens").start()
end

--- Move to the previous search match with glow and highlight lenses.
---@type UndoGlowAction
function M.search_previous()
  require("undo-glow").search_prev(search_options)
  require("hlslens").start()
end

return M

local fzf_actions = nil

local M = {}

function M.toggle_visibility_actions()
  if not fzf_actions then
    fzf_actions = require("fzf-lua.actions")
  end

  return {
    ["ctrl-u"] = { fzf_actions.toggle_hidden, { desc = "Toggle hidden" } },
    ["ctrl-o"] = { fzf_actions.toggle_ignore, { desc = "Toggle ignore" } },
  }
end

return M

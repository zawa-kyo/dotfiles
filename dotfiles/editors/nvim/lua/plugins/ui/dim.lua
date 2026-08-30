local enabled = false

local function toggle_dim()
  local Snacks = require("snacks")
  enabled = not enabled
  if enabled then
    Snacks.dim.enable()
  else
    Snacks.dim.disable()
  end
end

return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  keys = {
    {
      "tD",
      toggle_dim,
      desc = "Toggle dim",
    },
  },
}

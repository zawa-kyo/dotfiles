-- Module for utility functions
local M = {}

--- Check if a value is not nil
--- @param value any The value to check
--- @return boolean Whether the value is not nil
function M.isNotNil(value)
  return value ~= nil
end

--- Check if a value is a string
--- @param value any The value to check
--- @return boolean Whether the value is not nil
function M.isString(value)
  return type(value) == "string"
end

--- Check if a value is a boolean
--- @param value any The value to check
--- @return boolean Whether the value is a boolean
function M.isBoolean(value)
  return type(value) == "boolean"
end

--- Get options with a description
--- @param desc string|nil Description of the mapping
--- @param is_noremap boolean|nil Whether the mapping should be noremap (default: true)
--- @param is_silent boolean|nil Whether the mapping should be silent (default: true)
--- @param is_expr boolean|nil Whether the mapping should be an expression (default: false)
--- @return table opts A table containing keymap options
function M.getOpts(desc, is_noremap, is_silent, is_expr)
  -- Default options
  local options = {
    noremap = true,
    silent = true,
    expr = false,
  }

  if M.isBoolean(is_noremap) then
    options.noremap = is_noremap
  end

  if M.isBoolean(is_silent) then
    options.silent = is_silent
  end

  if M.isBoolean(is_expr) then
    options.expr = is_expr
  end

  if M.isString(desc) then
    options.desc = desc
  end

  return options
end

--- Map VSCode command to a normal-mode keymap when running under VSCode
--- @param lhs string The keybinding on the Neovim side
--- @param command string The VSCode command id to trigger
--- @param desc string|nil Description shown in which-key/help
function M.vscode_map(lhs, command, desc)
  if not vim.g.vscode then
    return
  end

  vim.keymap.set("n", lhs, function()
    vim.fn.VSCodeNotify(command)
  end, M.getOpts(desc))
end

return M

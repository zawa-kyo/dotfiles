---@alias PickerAction fun()
---@alias PickerOperation fun(picker: snacks.picker)
---@class PickerActions
local M = {}

local colorscheme_picker = require("plugins.picker.colorschemes")
local file_visibility = require("plugins.files.visibility")
local grep = require("plugins.picker.grep")
local snippets = require("plugins.picker.snippets")

-- Return the Snacks picker API.
---@return snacks.picker
local function picker()
  return require("snacks").picker
end

-- Build an action that opens a Snacks picker source.
---@param open PickerOperation
---@return PickerAction
local function picker_action(open)
  return function()
    open(picker())
  end
end

--- Open the repository's filtered colorscheme picker.
---@return PickerAction
local function search_colorschemes()
  return function()
    colorscheme_picker.open(picker)
  end
end

--- Open the buffer picker.
---@type PickerAction
M.search_buffers = picker_action(function(value)
  value.buffers()
end)

--- Search lines in the current buffer.
---@type PickerAction
M.search_buffer_lines = picker_action(function(value)
  value.lines()
end)

--- Show diagnostics in the current buffer.
---@type PickerAction
M.search_buffer_diagnostics = picker_action(function(value)
  value.diagnostics_buffer()
end)

--- Show diagnostics in the workspace.
---@type PickerAction
M.search_diagnostics = picker_action(function(value)
  value.diagnostics()
end)

--- Open the repository's filtered colorscheme picker.
---@type PickerAction
M.search_colorschemes = search_colorschemes()

--- Search lines in open buffers.
---@type PickerAction
M.search_current_buffers = picker_action(function(value)
  value.grep_buffers()
end)

--- Search directories with zoxide.
---@type PickerAction
M.search_directories = picker_action(function(value)
  value.zoxide()
end)

--- Search files in the workspace.
---@type PickerAction
M.search_files = picker_action(function(value)
  value.files(file_visibility.navigation_opts())
end)

--- Search Git branches.
---@type PickerAction
M.search_git_branches = picker_action(function(value)
  value.git_branches()
end)

--- Search Git diffs.
---@type PickerAction
M.search_git_diff = picker_action(function(value)
  value.git_diff()
end)

--- Search the current file's Git log.
---@type PickerAction
M.search_git_file_log = picker_action(function(value)
  value.git_log_file()
end)

--- Search tracked Git files.
---@type PickerAction
M.search_git_files = picker_action(function(value)
  value.git_files()
end)

--- Search Git log lines.
---@type PickerAction
M.search_git_line_log = picker_action(function(value)
  value.git_log_line()
end)

--- Search Git logs.
---@type PickerAction
M.search_git_log = picker_action(function(value)
  value.git_log()
end)

--- Search Git stashes.
---@type PickerAction
M.search_git_stash = picker_action(function(value)
  value.git_stash()
end)

--- Search Git status.
---@type PickerAction
M.search_git_status = picker_action(function(value)
  value.git_status()
end)

--- Search help tags.
---@type PickerAction
M.search_help = picker_action(function(value)
  value.help()
end)

--- Search icons.
---@type PickerAction
M.search_icons = picker_action(function(value)
  value.icons()
end)

--- Search keymaps.
---@type PickerAction
M.search_keymaps = picker_action(function(value)
  value.keymaps()
end)

--- Search marks.
---@type PickerAction
M.search_marks = picker_action(function(value)
  value.marks()
end)

--- Search notifications.
---@type PickerAction
M.search_notifications = picker_action(function(value)
  value.notifications()
end)

--- Search picker sources.
---@type PickerAction
M.search_picker_sources = picker_action(function(value)
  value.pickers()
end)

--- Search projects.
---@type PickerAction
M.search_projects = picker_action(function(value)
  value.projects()
end)

--- Search the quickfix list.
---@type PickerAction
M.search_quickfix = picker_action(function(value)
  value.qflist()
end)

--- Search recent files.
---@type PickerAction
M.search_recent_files = picker_action(function(value)
  value.recent()
end)

--- Search registers.
---@type PickerAction
M.search_registers = picker_action(function(value)
  value.registers()
end)

--- Search snippets.
---@type PickerAction
M.search_snippets = snippets.search_snippets

--- Search files and words.
---@type PickerAction
M.search_smart = picker_action(function(value)
  value.smart()
end)

--- Search LSP symbols in the current buffer.
---@type PickerAction
M.search_symbols = picker_action(function(value)
  value.lsp_symbols()
end)

--- Search Tree-sitter symbols.
---@type PickerAction
M.search_treesitter_symbols = picker_action(function(value)
  value.treesitter()
end)

--- Search undo history.
---@type PickerAction
M.search_undos = picker_action(function(value)
  value.undo()
end)

--- Search LSP symbols in the workspace.
---@type PickerAction
M.search_workspace_symbols = picker_action(function(value)
  value.lsp_workspace_symbols()
end)

--- Toggle hidden files.
---@type PickerAction
M.toggle_hidden = file_visibility.toggle_hidden

--- Toggle Git-ignored files.
---@type PickerAction
M.toggle_ignored = file_visibility.toggle_ignored

-- Search lines across the workspace with natural glob support.
---@type PickerAction
function M.search_workspace_lines()
  grep.open(file_visibility.search_opts())
end

-- Resume the most recently used picker.
---@type PickerAction
M.resume = picker_action(function(value)
  value.resume()
end)

return M

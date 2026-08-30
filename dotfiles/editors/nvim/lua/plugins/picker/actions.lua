---@alias PickerAction fun(): any
---@class PickerActions
---@field search_buffers PickerAction Open the buffer picker.
---@field search_buffer_lines PickerAction Search lines in the current buffer.
---@field search_buffer_diagnostics PickerAction Show diagnostics in the current buffer.
---@field search_diagnostics PickerAction Show diagnostics in the workspace.
---@field search_colorschemes PickerAction Open the colorscheme picker.
---@field search_current_buffers PickerAction Search lines in open buffers.
---@field search_directories PickerAction Search directories with zoxide.
---@field search_files PickerAction Search files in the workspace.
---@field search_git_branches PickerAction Search Git branches.
---@field search_git_diff PickerAction Search Git diffs.
---@field search_git_file_log PickerAction Search the current file's Git log.
---@field search_git_files PickerAction Search tracked Git files.
---@field search_git_line_log PickerAction Search Git log lines.
---@field search_git_log PickerAction Search Git logs.
---@field search_git_stash PickerAction Search Git stashes.
---@field search_git_status PickerAction Search Git status.
---@field search_help PickerAction Search help tags.
---@field search_icons PickerAction Search icons.
---@field search_keymaps PickerAction Search keymaps.
---@field search_marks PickerAction Search marks.
---@field search_notifications PickerAction Search notifications.
---@field search_picker_sources PickerAction Search picker sources.
---@field search_projects PickerAction Search projects.
---@field search_quickfix PickerAction Search the quickfix list.
---@field search_recent_files PickerAction Search recent files.
---@field search_registers PickerAction Search registers.
---@field search_snippets PickerAction Search snippets.
---@field search_smart PickerAction Search files and words.
---@field search_symbols PickerAction Search LSP symbols in the current buffer.
---@field search_treesitter_symbols PickerAction Search Tree-sitter symbols.
---@field search_undos PickerAction Search undo history.
---@field search_workspace_lines PickerAction Search lines across the workspace.
---@field search_workspace_symbols PickerAction Search LSP symbols in the workspace.
---@field toggle_hidden PickerAction Toggle hidden files.
---@field toggle_ignored PickerAction Toggle Git-ignored files.
---@field resume PickerAction Resume the previous picker.
---@type PickerActions
local M = {}

local colorscheme_picker = require("plugins.picker.colorschemes")
local file_visibility = require("plugins.files.visibility")
local grep = require("plugins.picker.grep")
local snippets = require("plugins.picker.snippets")

-- Return the Snacks picker API.
local function picker()
  return require("snacks").picker
end

-- Build an action that opens a Snacks picker source.
---@param source string
---@param opts? fun(): table
---@return PickerAction
local function picker_action(source, opts)
  return function()
    if opts then
      return picker()[source](opts())
    end
    return picker()[source]()
  end
end

M.search_buffers = picker_action("buffers")
M.search_buffer_lines = picker_action("lines")
M.search_buffer_diagnostics = picker_action("diagnostics_buffer")
M.search_diagnostics = picker_action("diagnostics")
-- Open the repository's filtered colorscheme picker.
M.search_colorschemes = function()
  return colorscheme_picker.open(picker)
end
M.search_current_buffers = picker_action("grep_buffers")
M.search_directories = picker_action("zoxide")
M.search_files = picker_action("files", file_visibility.navigation_opts)
M.search_git_branches = picker_action("git_branches")
M.search_git_diff = picker_action("git_diff")
M.search_git_file_log = picker_action("git_log_file")
M.search_git_files = picker_action("git_files")
M.search_git_line_log = picker_action("git_log_line")
M.search_git_log = picker_action("git_log")
M.search_git_stash = picker_action("git_stash")
M.search_git_status = picker_action("git_status")
M.search_help = picker_action("help")
M.search_icons = picker_action("icons")
M.search_keymaps = picker_action("keymaps")
M.search_marks = picker_action("marks")
M.search_notifications = picker_action("notifications")
M.search_picker_sources = picker_action("pickers")
M.search_projects = picker_action("projects")
M.search_quickfix = picker_action("qflist")
M.search_recent_files = picker_action("recent")
M.search_registers = picker_action("registers")
M.search_snippets = snippets.search_snippets
M.search_smart = picker_action("smart")
M.search_symbols = picker_action("lsp_symbols")
M.search_treesitter_symbols = picker_action("treesitter")
M.search_undos = picker_action("undo")
M.search_workspace_symbols = picker_action("lsp_workspace_symbols")
M.toggle_hidden = file_visibility.toggle_hidden
M.toggle_ignored = file_visibility.toggle_ignored

-- Search lines across the workspace with natural glob support.
function M.search_workspace_lines()
  return grep.open(file_visibility.search_opts())
end

-- Resume the most recently used picker.
M.resume = picker_action("resume")

return M

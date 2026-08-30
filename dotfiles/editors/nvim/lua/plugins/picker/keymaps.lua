local M = {}

local actions = require("plugins.picker.actions")

M.keys = {
  {
    "sb",
    actions.search_buffers,
    desc = "Search buffers",
  },
  {
    "sB",
    actions.search_current_buffers,
    desc = "Search lines in current buffers",
  },
  {
    "sc", -- search colorschemes
    actions.search_colorschemes,
    desc = "Search colorschemes",
  },
  {
    "sd",
    actions.search_buffer_diagnostics,
    desc = "Search diagnostics in current buffer",
  },
  {
    "sD",
    actions.search_diagnostics,
    desc = "Search diagnostics in workspace",
  },
  {
    "sf",
    actions.search_files,
    desc = "Search files in workspace",
  },
  {
    "sF",
    actions.search_recent_files,
    desc = "Search recent files",
  },
  {
    "sgb",
    actions.search_git_branches,
    desc = "Search git branches",
  },
  {
    "sgd",
    actions.search_git_diff,
    desc = "Search git diffs (hunks)",
  },
  {
    "sgf",
    actions.search_git_file_log,
    desc = "Search git log file",
  },
  {
    "sgF",
    actions.search_git_files,
    desc = "Search git files",
  },
  {
    "sgl",
    actions.search_git_log,
    desc = "Search git logs",
  },
  {
    "sgL",
    actions.search_git_line_log,
    desc = "Search git log lines",
  },
  {
    "sgs",
    actions.search_git_status,
    desc = "Search git status",
  },
  {
    "sgS",
    actions.search_git_stash,
    desc = "Search git stash",
  },
  {
    "sh",
    actions.search_help,
    desc = "Search helps",
  },
  {
    "si",
    actions.search_icons,
    desc = "Search icons",
  },
  {
    "sk",
    actions.search_keymaps,
    desc = "Search keymaps",
  },
  {
    "sl",
    actions.search_buffer_lines,
    desc = "Search lines in current buffer",
  },
  {
    "sm",
    actions.search_smart,
    desc = "Smart search for files and words",
  },
  {
    "sM",
    actions.search_marks,
    desc = "Search marks",
  },
  {
    "sn",
    actions.search_notifications,
    desc = "Search notifications",
  },
  {
    "sN", -- search snippets
    actions.search_snippets,
    desc = "Search snippets",
  },
  {
    "sp",
    actions.search_picker_sources,
    desc = "Search pickers",
  },
  {
    "sP",
    actions.search_projects,
    desc = "Search projects",
  },
  {
    "sq",
    actions.search_quickfix,
    desc = "Search quickfix list",
  },
  {
    "sr",
    actions.search_registers,
    desc = "Search registers",
  },
  {
    "sR",
    actions.resume,
    desc = "Resume previous picker",
  },
  {
    "ss",
    actions.search_symbols,
    desc = "Search LSP symbols in current buffer",
  },
  {
    "sS",
    actions.search_workspace_symbols,
    desc = "Search LSP symbols in workspace",
  },
  {
    "st",
    actions.search_treesitter_symbols,
    desc = "Search Tree-sitter symbols in current buffer",
  },
  {
    "su",
    actions.search_undos,
    desc = "Search undos",
  },
  {
    "sL",
    actions.search_workspace_lines,
    desc = "Search lines in workspace",
  },
  {
    "sz",
    actions.search_directories,
    desc = "Search directories via zoxide",
  },
  {
    "th", -- toggle hidden files
    actions.toggle_hidden,
    desc = "Toggle dotfiles in file navigation",
  },
  {
    "ti", -- toggle ignored files
    actions.toggle_ignored,
    desc = "Toggle Git-ignored files in file navigation",
  },
}

M.vscode = function()
  local utils = require("config.utils")

  utils.vscode_map("sf", "workbench.action.quickOpen", "Search files in workspace (VSCode)")
  utils.vscode_map("sL", "workbench.action.findInFiles", "Search lines in workspace (VSCode)")
  utils.vscode_map("sl", "actions.find", "Search lines in file (VSCode)")
  utils.vscode_map("/", "actions.find", "Search lines in file (VSCode)")
end

return M

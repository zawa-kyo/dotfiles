local M = {}

local file_exclusions = require("config.file-exclusions")
local utils = require("config.utils")
local is_hidden_visible = true

-- Resolve the project root using common project markers.
local function project_root()
  local root = vim.fs.root(0, { ".git", "Makefile", "package.json" })
  return root or (vim.uv.cwd() or vim.fn.getcwd())
end

-- Build a branch list from root to target for mini.files navigation.
local function make_branch(root, target)
  local normalized_root = vim.fs.normalize(root)
  local normalized_target = vim.fs.normalize(target)

  if normalized_root == normalized_target then
    return { normalized_root }
  end

  local prefix = normalized_root .. "/"
  if not vim.startswith(normalized_target, prefix) then
    return { normalized_root }
  end

  local relative = normalized_target:sub(#prefix + 1)
  local parts = vim.split(relative, "/", { plain = true, trimempty = true })
  local branch = { normalized_root }
  local current = normalized_root

  for _, part in ipairs(parts) do
    current = current .. "/" .. part
    table.insert(branch, current)
  end

  return branch
end

-- Focus an entry inside a directory view without expanding previews.
local function focus_entry_in_dir(dir_path, entry_name)
  local mini_files = require("mini.files")
  local state = mini_files.get_explorer_state()
  if not state then
    return
  end

  local normalized_dir = vim.fs.normalize(dir_path)
  local target_win
  for _, win in ipairs(state.windows) do
    if vim.fs.normalize(win.path) == normalized_dir then
      target_win = win.win_id
      break
    end
  end

  if not target_win then
    return
  end

  local buf_id = vim.api.nvim_win_get_buf(target_win)
  local line_count = vim.api.nvim_buf_line_count(buf_id)
  for line = 1, line_count do
    local entry = mini_files.get_fs_entry(buf_id, line)
    if entry and entry.name == entry_name then
      vim.api.nvim_win_set_cursor(target_win, { line, 0 })
      return
    end
  end
end

-- Decide whether to show a file system entry.
local function filter_entry(entry)
  if file_exclusions.contains(entry.name) then
    return false
  end

  return is_hidden_visible or not vim.startswith(entry.name, ".")
end

-- Toggle dotfile visibility and refresh mini.files.
local function toggle_hidden()
  is_hidden_visible = not is_hidden_visible
  require("mini.files").refresh({
    content = {
      filter = filter_entry,
    },
  })
end

-- Close mini.files unless the current search highlight should be cleared first.
local function close_or_clear_search()
  if vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
    return
  end

  require("mini.files").close()
end

-- Open the project root and reveal the current file when possible.
function M.open_project_reveal()
  local mini_files = require("mini.files")
  local root = project_root()
  local target = vim.api.nvim_buf_get_name(0)

  mini_files.open(root, false)

  if target ~= "" and vim.fn.filereadable(target) == 1 then
    vim.schedule(function()
      local normalized_target = vim.fs.normalize(target)
      local parent = vim.fs.dirname(normalized_target)

      mini_files.set_branch(make_branch(root, parent))
      focus_entry_in_dir(parent, vim.fs.basename(normalized_target))
    end)
  end
end

-- Open mini.files at the project root without revealing a file.
function M.open_project_root()
  require("mini.files").open(project_root(), false)
end

-- Configure mini.files and its buffer-local keymaps.
function M.setup()
  local keymap = utils.getKeymap
  local keymap_group = vim.api.nvim_create_augroup("MiniFilesKeymaps", { clear = true })

  require("mini.files").setup({
    content = {
      filter = filter_entry,
    },
    mappings = {
      go_in = "l",
      go_in_plus = "<CR>",
    },
    options = {
      use_as_default_explorer = true,
      use_trash = true,
    },
  })

  vim.api.nvim_create_autocmd("User", {
    group = keymap_group,
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      keymap("n", "H", toggle_hidden, { buffer = buf_id, desc = "Toggle hidden files" })
      keymap("n", "<Esc>", close_or_clear_search, { buffer = buf_id, desc = "Close mini.files" })
    end,
  })
end

return M

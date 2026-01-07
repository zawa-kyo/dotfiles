local utils = require("config.utils")
local file_ignore = require("config.file-ignore")
local is_hidden_visible = true

--- Resolve the project root using project.nvim or common markers.
local function project_root()
  local ok, project = pcall(require, "project_nvim.project")
  if ok then
    local root = project.get_project_root()
    if root and root ~= "" then
      return root
    end
  end

  local root = vim.fs.root(0, { ".git", "Makefile", "package.json" })
  return root or (vim.loop.cwd() or vim.fn.getcwd())
end

--- Build a branch list from root to target for mini.files navigation.
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

--- Focus the entry name inside the directory view without expanding previews.
local function focus_entry_in_dir(dir_path, entry_name)
  local state = require("mini.files").get_explorer_state()
  if not state then
    return
  end

  local normalized_dir = vim.fs.normalize(dir_path)
  local target_win = nil
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
    local entry = require("mini.files").get_fs_entry(buf_id, line)
    if entry and entry.name == entry_name then
      vim.api.nvim_win_set_cursor(target_win, { line, 0 })
      return
    end
  end
end

--- Open project root and highlight the current file entry if it exists.
local function open_project_reveal()
  local root = project_root()
  local target = vim.api.nvim_buf_get_name(0)

  require("mini.files").open(root, false)

  if target ~= "" and vim.fn.filereadable(target) == 1 then
    vim.schedule(function()
      local normalized_target = vim.fs.normalize(target)
      local parent = vim.fs.dirname(normalized_target)

      require("mini.files").set_branch(make_branch(root, parent))
      focus_entry_in_dir(parent, vim.fs.basename(normalized_target))
    end)
  end
end

--- Open project root without revealing any file.
local function open_project_root()
  require("mini.files").open(project_root(), false)
end

--- Decide whether to show a file system entry based on hidden visibility.
local function filter_hidden(entry)
  if file_ignore.is_ignored(entry.name) then
    return false
  end

  return is_hidden_visible or not vim.startswith(entry.name, ".")
end

--- Toggle hidden file visibility and refresh the explorer view.
local function toggle_hidden()
  is_hidden_visible = not is_hidden_visible
  require("mini.files").refresh()
end

return {
  "echasnovski/mini.files",
  cond = not vim.g.vscode,

  keys = {
    {
      "-",
      open_project_reveal,
      desc = "Open mini.files (project root, reveal file)",
    },
    {
      "_",
      open_project_root,
      desc = "Open mini.files (project root)",
    },
  },
  config = function()
    local keymap = utils.getKeymap

    require("mini.files").setup({
      content = {
        filter = filter_hidden,
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

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "minifiles",
      callback = function(args)
        keymap("n", "H", toggle_hidden, { buffer = args.buf, desc = "Toggle hidden files" })
        keymap("n", "<Esc>", function()
          if vim.v.hlsearch == 1 then
            vim.cmd("nohlsearch")
            return
          end

          require("mini.files").close()
        end, { buffer = args.buf, desc = "Close mini.files" })
      end,
    })
  end,
}

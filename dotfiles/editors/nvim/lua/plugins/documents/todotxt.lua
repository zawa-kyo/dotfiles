-- Report todotxt.nvim setup failures through the configured notification history.
local function notify_setup_error(message)
  vim.notify(message, vim.log.levels.ERROR, { title = "todotxt.nvim" })
end

-- Create an empty todo.txt data file when it does not exist.
local function ensure_file(path)
  local stat = vim.uv.fs_stat(path)
  if stat then
    if stat.type == "file" then
      return true
    end
    return false, path .. " exists and is not a file"
  end

  local ok, result = pcall(vim.fn.writefile, {}, path)
  if not ok then
    return false, result
  end
  if result ~= 0 then
    return false, "writefile returned " .. result .. " for " .. path
  end
  return true
end

-- Prepare todo.txt storage and configure the plugin.
local function setup_todotxt()
  local todo_notes_dir = vim.env.DIR_TODO_NOTES
  if not todo_notes_dir or todo_notes_dir == "" then
    notify_setup_error("DIR_TODO_NOTES is not set")
    return
  end

  todo_notes_dir = vim.fs.normalize(todo_notes_dir)
  local ok, result = pcall(vim.fn.mkdir, todo_notes_dir, "p")
  if not ok or result == -1 or vim.fn.isdirectory(todo_notes_dir) ~= 1 then
    notify_setup_error("Failed to create todo notes directory: " .. todo_notes_dir .. ": " .. tostring(result))
    return
  end

  local todotxt = vim.fs.joinpath(todo_notes_dir, "todo.txt")
  local donetxt = vim.fs.joinpath(todo_notes_dir, "done.txt")
  for _, path in ipairs({ todotxt, donetxt }) do
    local created, err = ensure_file(path)
    if not created then
      notify_setup_error("Failed to create todo.txt data file: " .. tostring(err))
      return
    end
  end

  local configured, err = pcall(function()
    require("todotxt").setup({
      todotxt = todotxt,
      donetxt = donetxt,
      ghost_text = { enable = false },
    })
  end)
  if not configured then
    notify_setup_error("Failed to configure todotxt.nvim: " .. tostring(err))
  end
end

return {
  "phrmendes/todotxt.nvim",

  ft = "todotxt",
  cmd = { "TodoTxt", "DoneTxt" },
  cond = not vim.g.vscode,

  init = function()
    vim.filetype.add({
      filename = {
        ["todo.txt"] = "todotxt",
        ["done.txt"] = "todotxt",
      },
    })
  end,

  keys = {
    {
      "<leader>tn",
      "<Cmd>TodoTxt new<CR>",
      desc = "New todo entry",
    },
    {
      "<leader>tt",
      "<Cmd>TodoTxt<CR>",
      desc = "Toggle todo.txt",
    },
    {
      "<leader>td",
      "<Cmd>DoneTxt<CR>",
      desc = "Toggle done.txt",
    },
    {
      "<leader>tg",
      "<Cmd>TodoTxt ghost<CR>",
      desc = "Toggle todo ghost text",
    },
  },

  config = setup_todotxt,
}

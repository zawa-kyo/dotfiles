local preview_windows = {}
local markdown_filetypes = {
  markdown = true,
  ["markdown.mdx"] = true,
}

local function is_markdown_buffer(bufnr)
  return markdown_filetypes[vim.bo[bufnr].filetype] == true
end

local function toggle_split_preview()
  local source_buf = vim.api.nvim_get_current_buf()
  if not is_markdown_buffer(source_buf) then
    return
  end

  local existing_win = preview_windows[source_buf]
  if existing_win and vim.api.nvim_win_is_valid(existing_win) then
    vim.api.nvim_win_close(existing_win, true)
    preview_windows[source_buf] = nil
    return
  end

  local source_win = vim.api.nvim_get_current_win()
  local before = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    before[win] = true
  end

  vim.cmd("botright vertical MdRender split")

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not before[win] then
      preview_windows[source_buf] = win
      break
    end
  end

  if vim.api.nvim_win_is_valid(source_win) then
    vim.api.nvim_set_current_win(source_win)
  end
end

return {
  "delphinus/md-render.nvim",
  version = "*",
  ft = { "markdown", "markdown.mdx" },
  cmd = { "MdRender" },
  cond = not vim.g.vscode,

  dependencies = {
    "DaikyXendo/nvim-material-icon",
    "delphinus/budoux.lua",
  },

  init = function()
    local group = vim.api.nvim_create_augroup("markdown_preview_preferences", { clear = true })

    vim.api.nvim_create_autocmd("BufWipeout", {
      group = group,
      callback = function(args)
        preview_windows[args.buf] = nil
      end,
      desc = "Clear cached Markdown preview window ids",
    })
  end,

  keys = {
    {
      "tmp",
      toggle_split_preview,
      desc = "Toggle Markdown split preview",
    },
    {
      "tmr",
      function()
        vim.cmd("MdRender toggle")
      end,
      desc = "Toggle Markdown rendering in the current window",
    },
  },
}

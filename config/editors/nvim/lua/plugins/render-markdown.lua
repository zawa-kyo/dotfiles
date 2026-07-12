local preview_windows = {}
local markdown_filetypes = {
  markdown = true,
  ["markdown.mdx"] = true,
}

local function is_markdown_buffer(bufnr)
  return markdown_filetypes[vim.bo[bufnr].filetype] == true
end

local function get_preview_window(tabpage, bufnr)
  local tab_windows = preview_windows[tabpage]
  if not tab_windows then
    return nil
  end
  return tab_windows[bufnr]
end

local function set_preview_window(tabpage, bufnr, winid)
  preview_windows[tabpage] = preview_windows[tabpage] or {}
  preview_windows[tabpage][bufnr] = winid
end

local function clear_preview_window(tabpage, bufnr)
  local tab_windows = preview_windows[tabpage]
  if not tab_windows then
    return
  end
  tab_windows[bufnr] = nil
  if next(tab_windows) == nil then
    preview_windows[tabpage] = nil
  end
end

local function toggle_split_preview()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local source_buf = vim.api.nvim_get_current_buf()
  if not is_markdown_buffer(source_buf) then
    return
  end

  local existing_win = get_preview_window(tabpage, source_buf)
  if existing_win and vim.api.nvim_win_is_valid(existing_win) then
    vim.api.nvim_win_close(existing_win, true)
    clear_preview_window(tabpage, source_buf)
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
      set_preview_window(tabpage, source_buf, win)
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
        for tabpage, tab_windows in pairs(preview_windows) do
          if tab_windows[args.buf] ~= nil then
            clear_preview_window(tabpage, args.buf)
          end
        end
      end,
      desc = "Clear cached Markdown preview window ids",
    })

    vim.api.nvim_create_autocmd("TabClosedPre", {
      group = group,
      callback = function()
        preview_windows[vim.api.nvim_get_current_tabpage()] = nil
      end,
      desc = "Clear cached Markdown preview windows for closed tabs",
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

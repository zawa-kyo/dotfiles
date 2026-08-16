local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

--- Get the visual selection range, normalized to start <= end.
--- @return number start_row
--- @return number start_col
--- @return number end_row
--- @return number end_col
local function get_visual_selection()
  local mode = vim.fn.mode()
  local start_pos
  local end_pos

  if mode == "v" or mode == "V" or mode == "\22" then
    start_pos = vim.fn.getpos("v")
    end_pos = vim.fn.getpos(".")
  else
    start_pos = vim.fn.getpos("'<")
    end_pos = vim.fn.getpos("'>")
  end
  local start_row = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3] - 1

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  return start_row, start_col, end_row, end_col
end

--- Replace the visual selection with a Markdown link using the clipboard URL.
--- Falls back to plain paste with a warning if the clipboard isn't an http/https URL.
local function paste_markdown_link()
  local url = vim.fn.getreg("+")
  if url == "" then
    vim.notify("Clipboard is empty.", vim.log.levels.WARN, { title = "Markdown Link" })
    return
  end

  url = vim.fn.trim(url):gsub("%s+", " ")

  if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "\22" then
    vim.cmd("normal! \\<Esc>")
  end

  local start_row, start_col, end_row, end_col = get_visual_selection()
  local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
  local text = table.concat(lines, "\n")
  if text == "" then
    vim.notify("No text selected.", vim.log.levels.WARN, { title = "Markdown Link" })
    return
  end

  if not url:match("^https?://") then
    vim.notify("Clipboard is not a URL. Using it as the link target.", vim.log.levels.WARN, { title = "Markdown Link" })
  end

  local replacement = "[" .. text .. "](" .. url .. ")"
  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 1, { replacement })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function(args)
    local map_opts = opts("Paste markdown link")
    map_opts.buffer = args.buf
    keymap("x", "mmp", paste_markdown_link, map_opts)
  end,
})

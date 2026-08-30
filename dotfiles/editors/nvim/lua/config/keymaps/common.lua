local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

--------------------
-- All Modes
--------------------

local all_modes_without_terminal = { "n", "i", "v", "x", "o", "c", "s" }

-- Disable arrow keys to encourage hjkl
keymap(all_modes_without_terminal, "<Up>", "<Nop>", opts("Nop"))
keymap(all_modes_without_terminal, "<Down>", "<Nop>", opts("Nop"))
keymap(all_modes_without_terminal, "<Left>", "<Nop>", opts("Nop"))
keymap(all_modes_without_terminal, "<Right>", "<Nop>", opts("Nop"))

--------------------
-- Normal Mode
--------------------

-- Better transition to command-line mode
-- Note: Enabling ‘silent’ may cause rendering delay
keymap("n", "<leader><leader>", ":", opts("Show command-line mode", true, false, nil))

-- File operations
keymap("n", "<leader>s", "<Cmd>write<CR>", opts("Write current buffer"))
keymap("n", "<leader>q", "<Cmd>quit<CR>", opts("Quit window"))

-- Window navigation (Ctrl+h/j/k/l)
keymap("n", "<C-h>", "<C-w>h", opts("Go to left window"))
keymap("n", "<C-j>", "<C-w>j", opts("Go to bottom window"))
keymap("n", "<C-k>", "<C-w>k", opts("Go to top window"))
keymap("n", "<C-l>", "<C-w>l", opts("Go to right window"))
keymap("n", "[w", "<C-w>W", opts("Go to previous window"))
keymap("n", "]w", "<C-w>w", opts("Go to next window"))

-- Window operations (<leader>w…)
keymap("n", "<leader>ws", ":split<CR><C-w>w", opts("Split window horizontally"))
keymap("n", "<leader>wv", ":vsplit<CR><C-w>w", opts("Split window vertically"))
keymap("n", "<leader>w=", "<C-w>=", opts("Equalize window sizes"))
keymap("n", "<leader>wq", "<C-w>q", opts("Close the current window"))
keymap("n", "<leader>wo", "<C-w>o", opts("Close other windows"))
keymap("n", "<leader>wx", "<C-w>x", opts("Swap with adjacent window"))
keymap("n", "<leader>w<", "5<C-w><", opts("Decrease window width"))
keymap("n", "<leader>w>", "5<C-w>>", opts("Increase window width"))
keymap("n", "<leader>w-", "5<C-w>-", opts("Decrease window height"))
keymap("n", "<leader>w+", "5<C-w>+", opts("Increase window height"))

-- Buffer operations (<leader>b…)
keymap("n", "<leader>bb", "<Cmd>ls<CR>", opts("Browse buffers"))
keymap("n", "<leader>bd", "<Cmd>bdelete<CR>", opts("Delete buffer"))
keymap("n", "<leader>bq", "<Cmd>bdelete<CR>", opts("Delete buffer"))
keymap("n", "<leader>br", "<Cmd>edit!<CR>", opts("Reload buffer"))
keymap("n", "]b", "<Cmd>bnext<CR>", opts("Go to next buffer"))
keymap("n", "[b", "<Cmd>bprevious<CR>", opts("Go to previous buffer"))

-- Tab operations (<leader>T…)
keymap("n", "<leader>Tn", "<Cmd>tabnew<CR>", opts("Open new tab"))
keymap("n", "<leader>Ts", "<Cmd>tab split<CR>", opts("Split to new tab"))
keymap("n", "<leader>Tq", "<Cmd>tabclose<CR>", opts("Close tab"))
keymap("n", "]t", "gt", opts("Go to next tab"))
keymap("n", "[t", "gT", opts("Go to previous tab"))

-- Disable default substitute to free up "s/S", "r/R" prefix
keymap("n", "s", "<Nop>", opts("Disable substitute"))
keymap("n", "S", "<Nop>", opts("Disable substitute line"))
keymap("n", "r", "<Nop>", opts("Disable replace"))
keymap("n", "R", "<Nop>", opts("Disable replace line"))

-- Toggle fold column
keymap("n", "tF", function()
  vim.wo.foldcolumn = vim.wo.foldcolumn == "0" and "1" or "0"
end, opts("Toggle fold column"))

-- Toggle relative numbers
keymap("n", "tN", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, opts("Toggle relative numbers"))

-- Wrapped lines: move by screen line
keymap("n", "j", "gj", opts("Move down wrapped lines"))
keymap("n", "k", "gk", opts("Move up wrapped lines"))

-- Jump history
keymap("n", "]j", "<C-i>", opts("Jump to next jumplist location"))
keymap("n", "[j", "<C-o>", opts("Jump to previous jumplist location"))
keymap("n", "]]", "<C-i>", opts("Jump to next location"))
keymap("n", "[[", "<C-o>", opts("Jump to previous location"))

-- Sections
keymap("n", "]s", "<Cmd>normal! ]]<CR>", opts("Go to next section"))
keymap("n", "[s", "<Cmd>normal! [[<CR>", opts("Go to previous section"))

-- Add blank lines without entering Insert mode
keymap("n", "mo", function()
  vim.fn.append(vim.fn.line("."), "")
end, opts("Add blank line below"))
keymap("n", "mO", function()
  vim.fn.append(vim.fn.line(".") - 1, "")
end, opts("Add blank line above"))

---Prompt for replacement text and reuse the last search pattern.
---@param command string Command prefix such as "%s" or "cfdo %s"
---@param title string Notification title
---@param update boolean Whether to write changed buffers after replacement
local function replace_last_search(command, title, update)
  if vim.fn.getreg("/") == "" then
    vim.notify("Search pattern is empty", vim.log.levels.WARN, { title = title })
    return
  end

  local replacement = vim.fn.input("Replace with: ")
  local suffix = update and " | update" or ""

  vim.g.config_last_search_replacement = replacement
  local ok, err = pcall(vim.cmd, ([=[%s//\=g:config_last_search_replacement/gc%s]=]):format(command, suffix))
  vim.g.config_last_search_replacement = nil
  if not ok then
    error(err)
  end
end

---Find the current line match for a search pattern.
---@param pattern string Vim search pattern
---@return integer|nil start_col
---@return integer|nil end_col
---@return boolean zero_width
local function current_line_match(pattern)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local match = vim.fn.matchstrpos(line, pattern, cursor[2])
  if match[2] < 0 then
    return nil, nil, false
  end

  return match[2], match[3], match[3] <= match[2]
end

---Replace the current match with literal replacement text.
---@param pattern string Vim search pattern
---@param replacement string Replacement text
---@return boolean replaced
---@return string|nil error_reason
local function replace_current_match(pattern, replacement)
  local start_col, end_col, zero_width = current_line_match(pattern)
  if zero_width then
    return false, "zero_width"
  end

  if not start_col or not end_col then
    return false, "not_found"
  end

  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_text(0, row, start_col, row, end_col, { replacement })
  vim.api.nvim_win_set_cursor(0, { row + 1, start_col + #replacement })
  return true
end

---Replace the latest / or ? search pattern in the current file.
local function replace_last_search_in_file()
  local pattern = vim.fn.getreg("/")
  local title = "Replace in File"
  if pattern == "" then
    vim.notify("Search pattern is empty", vim.log.levels.WARN, { title = title })
    return
  end

  local replacement = vim.fn.input("Replace with: ")
  local replaced = 0
  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  while vim.fn.search(pattern, "cW") > 0 do
    vim.cmd("redraw")
    vim.api.nvim_echo({
      { "Replace m/atch? ", "Question" },
      { "n", "MoreMsg" },
      { "=next, " },
      { "s", "MoreMsg" },
      { "=skip, " },
      { "a", "MoreMsg" },
      { "=replace all, q=quit" },
    }, false, {})

    local key = vim.fn.getcharstr()
    if key == "q" or key == "\027" then
      break
    end

    if key == "a" then
      repeat
        local replaced_current, error_reason = replace_current_match(pattern, replacement)
        if error_reason == "zero_width" then
          vim.notify("Zero-width search patterns are not supported", vim.log.levels.WARN, { title = title })
          break
        end

        if replaced_current then
          replaced = replaced + 1
        end
      until vim.fn.search(pattern, "W") == 0
      break
    end

    if key == "n" then
      local replaced_current, error_reason = replace_current_match(pattern, replacement)
      if error_reason == "zero_width" then
        vim.notify("Zero-width search patterns are not supported", vim.log.levels.WARN, { title = title })
        break
      end

      if replaced_current then
        replaced = replaced + 1
      end
    elseif key == "s" then
      vim.fn.search(pattern, "W")
    end
  end

  vim.notify(("Replaced %d match%s"):format(replaced, replaced == 1 and "" or "es"), vim.log.levels.INFO, {
    title = title,
  })
end

-- Replace the latest / or ? search pattern without opening a separate UI.
keymap("n", "mw", function()
  replace_last_search_in_file()
end, opts("Replace last search in current file"))

keymap("n", "mW", function()
  local info = vim.fn.getqflist({ size = 0 })
  if not info or info.size == 0 then
    vim.notify("Quickfix list is empty", vim.log.levels.WARN, { title = "Replace in Quickfix Files" })
    return
  end

  replace_last_search("cfdo %s", "Replace in Quickfix Files", true)
end, opts("Replace last search in quickfix files"))

-- Marks (use M to avoid clashing with the modify prefix)
keymap("n", "M", "m", opts("Set mark"))

-- Match pairs (align with cycle-style [ ] prefix)
keymap("n", "]p", "%", opts("Go to matching pair"))
keymap("n", "[p", "%", opts("Go to matching pair"))

-- Mirror unnamed register into operator-specific registers (y/d/c)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("use-easy-regname", { clear = true }),
  callback = function()
    if vim.v.event.regname ~= "" then
      return
    end

    local op = vim.v.event.operator
    if op == "y" or op == "d" or op == "c" then
      vim.fn.setreg(op, vim.fn.getreg('"'), vim.fn.getregtype('"'))
    end
  end,
})

-- Clear specific register
keymap("n", "Xr", function()
  local reg = vim.fn.getcharstr()
  if reg:match("^[a-zA-Z]$") then
    local ok = pcall(vim.fn.setreg, reg, "")
    if ok then
      vim.notify("Cleared register: " .. reg, vim.log.levels.INFO, { title = "Registers" })
      return
    end
    vim.notify("Register is read-only: " .. reg, vim.log.levels.WARN, { title = "Registers" })
    return
  end
  vim.notify("Invalid register: " .. reg, vim.log.levels.WARN, { title = "Registers" })
end, opts("Clear register (a-z/A-Z)"))

local register_characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"=+*%#.:'

-- Clear all registers
keymap("n", "XR", function()
  for r in register_characters:gmatch(".") do
    pcall(vim.fn.setreg, r, "")
  end
  vim.notify("Cleared all registers", vim.log.levels.INFO, { title = "Registers" })
end, opts("Clear all registers"))

--------------------
-- Command-line
--------------------

-- After search, :s<Space> expands to :%s//g so you can replace the last match immediately.
vim.cmd(
  [[cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's']]
)

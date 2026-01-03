local utils = require("config.utils")
local file_ignore = require("config.file-ignore")
local keymap = utils.getKeymap

if not vim.g.vscode then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

if vim.g.vscode then
  utils.vscode_map("<leader>e", "workbench.action.toggleSidebarVisibility", "Toggle Explorer (VSCode)")
  utils.vscode_map("<leader>E", "workbench.action.toggleSidebarVisibility", "Toggle Explorer (VSCode)")
end

local state = {
  last_win = nil,
  last_pos = nil,
}

-- Remember the window and cursor position before opening Fern
local function remember_window()
  state.last_win = vim.api.nvim_get_current_win()
  state.last_pos = vim.api.nvim_win_get_cursor(0)
end

-- Restore focus to the previously saved window/cursor if still valid
local function restore_window()
  if state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
    vim.api.nvim_set_current_win(state.last_win)
    vim.api.nvim_win_set_cursor(state.last_win, state.last_pos)
  end
end

-- Determine the base directory Fern should use
local function fern_root()
  return vim.loop.cwd() or vim.fn.getcwd()
end

-- Open Fern as a drawer and optionally reveal the current file
local function open_fern_drawer(should_reveal)
  remember_window()

  vim.schedule(function()
    local root = fern_root()
    local current_file = vim.fn.expand("%:p")

    local reveal_cmd = ""
    if should_reveal and vim.fn.filereadable(current_file) == 1 then
      reveal_cmd = " -reveal=" .. vim.fn.fnameescape(current_file)
    end

    vim.cmd("Fern " .. vim.fn.fnameescape(root) .. " -drawer" .. reveal_cmd)

    local width = math.floor(vim.o.columns * 0.25)
    vim.cmd("vertical resize " .. width)
  end)
end

-- Toggle Fern and jump back to the last buffer if it's already open
local function toggle_fern_with_reveal()
  if vim.bo.filetype == "fern" then
    vim.cmd.wincmd("p")
    restore_window()
    return
  end

  open_fern_drawer(true)
end

-- Close Fern if active or open it when hidden
local function toggle_or_close_fern()
  if vim.bo.filetype == "fern" then
    vim.cmd("bd")
    restore_window()
    return
  end

  open_fern_drawer(false)
end

return {
  "lambdalisue/fern.vim",
  cond = not vim.g.vscode,
  dependencies = {
    "yuki-yano/fern-preview.vim",
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/glyph-palette.vim",
    "lambdalisue/nerdfont.vim",
  },
  keys = {
    { "<leader>fe", toggle_or_close_fern, desc = "Toggle or close Fern" },
    { "<leader>fE", toggle_fern_with_reveal, desc = "Toggle or reveal in Fern" },
  },
  config = function()
    vim.g["fern#default_hidden"] = 1
    vim.g["fern#default_exclude"] = file_ignore.fern_exclude()
    vim.g["fern#renderer"] = "nerdfont"

    local glyph_group = vim.api.nvim_create_augroup("FernGlyphPalette", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = glyph_group,
      pattern = "fern",
      callback = function()
        if vim.fn.exists("*glyph_palette#apply") == 1 then
          vim.fn["glyph_palette#apply"]()
        end
      end,
    })

    local fern_augroup = vim.api.nvim_create_augroup("FernCustom", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = fern_augroup,
      pattern = "fern",
      callback = function(event)
        local buffer = event.buf
        local mappings = {
          { "<CR>", "<Plug>(fern-action-open-or-expand)" },
          { "<S-CR>", "<Plug>(fern-action-collapse)" },
          { "H", "<Plug>(fern-action-hidden:toggle)" },
          { "p", "<Plug>(fern-action-preview:toggle)" },
        }

        for _, map in ipairs(mappings) do
          keymap("n", map[1], map[2], { buffer = buffer, noremap = false, silent = true })
        end
      end,
    })
  end,
}

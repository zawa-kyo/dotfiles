local utils = require("config.utils")

if vim.g.vscode then
  utils.vscode_map("<leader>e", "workbench.action.toggleSidebarVisibility", "Toggle Explorer (VSCode)")
  utils.vscode_map("<leader>E", "workbench.action.toggleSidebarVisibility", "Toggle Explorer (VSCode)")
end

-- Resolve the current project root so Fern opens relative to cwd changes
local function project_root()
  return vim.loop.cwd() or vim.fn.getcwd()
end
local last_file_state = nil

-- Jump back to the last non-Fern window/cursor position if possible
local function restore_last_window()
  if last_file_state and vim.api.nvim_win_is_valid(last_file_state.win) then
    vim.api.nvim_set_current_win(last_file_state.win)
    vim.api.nvim_win_set_cursor(last_file_state.win, last_file_state.pos)
  end
end

-- Open Fern as a drawer and optionally reveal the current buffer
local function open_fern_drawer()
  last_file_state = {
    win = vim.api.nvim_get_current_win(),
    pos = vim.api.nvim_win_get_cursor(0),
  }

  vim.schedule(function()
    local root = project_root()
    vim.fn.chdir(root)
    local current_file = vim.fn.expand("%:p")
    local reveal_cmd = ""
    if vim.fn.filereadable(current_file) == 1 then
      reveal_cmd = " -reveal=" .. vim.fn.fnameescape(current_file)
    end
    vim.cmd("Fern " .. vim.fn.fnameescape(root) .. " -drawer" .. reveal_cmd)

    local fern_width_ratio = 0.25
    local fern_width = math.floor(vim.o.columns * fern_width_ratio)
    vim.cmd("vertical resize " .. fern_width)
  end)
end

-- Toggle focus between Fern and last file, revealing the file when opening
local function toggle_fern_with_reveal()
  if vim.bo.filetype == "fern" then
    vim.cmd.wincmd("p")
    restore_last_window()
    return
  end
  open_fern_drawer()
end

-- Close Fern if visible or open it when hidden
local function toggle_or_close_fern()
  if vim.bo.filetype == "fern" then
    vim.cmd("bd")
    restore_last_window()
    return
  end
  toggle_fern_with_reveal()
end

return {
  "lambdalisue/fern.vim",
  cond = not vim.g.vscode,
  dependencies = {
    "lambdalisue/fern-hijack.vim",
    "yuki-yano/fern-preview.vim",
  },
  keys = {
    { "<leader>e", toggle_or_close_fern, desc = "Toggle or close Fern" },
    { "<leader>E", toggle_fern_with_reveal, desc = "Toggle or reveal in Fern" },
  },
  config = function()
    local fern_augroup = vim.api.nvim_create_augroup("FernCustom", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = fern_augroup,
      pattern = "fern",
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<Plug>(fern-action-open)", { noremap = false, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "p", "<Plug>(fern-action-preview:toggle)", { noremap = false, silent = true })
      end,
    })
  end,
}

local utils = require("config.utils")

-- Make sure future edits happen in a non-Fern window, splitting if needed
local function ensure_edit_window()
  if vim.bo.filetype ~= "fern" then
    return
  end

  vim.cmd.wincmd("p")
  if vim.bo.filetype ~= "fern" then
    return
  end

  vim.cmd.wincmd("l")
  if vim.bo.filetype ~= "fern" then
    return
  end

  vim.cmd("vsplit")
  vim.cmd("enew")
  vim.cmd.wincmd("l")
end

-- Run the given action after guaranteeing we are in an edit-friendly window
local function run_in_edit_window(action)
  ensure_edit_window()
  action()
end

if vim.g.vscode then
  utils.vscode_map("<leader>p", "workbench.action.quickOpen", "Quick Open (VSCode)")
  utils.vscode_map("<leader>g", "workbench.action.findInFiles", "Search in workspace (VSCode)")
  utils.vscode_map("<leader>f", "actions.find", "Search in file (VSCode)")
end

local M = {
  "ibhagwan/fzf-lua",

  lazy = true,
  cond = not vim.g.vscode,
  cmd = { "FzfLua" },

  keys = {
    {
      "<leader>p",
      function()
        run_in_edit_window(function()
          require("fzf-lua").files()
        end)
      end,
      desc = "Search files in the current directory",
    },
    {
      "<leader>g",
      function()
        run_in_edit_window(function()
          require("fzf-lua").live_grep()
        end)
      end,
      desc = "Search text in all files",
    },
    {
      "<leader>f",
      function()
        require("plugins.fzf").lines()
      end,
      desc = "Search text in the current file",
    },
  },

  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup({
          -- Avoid LSP-based root detection to prevent deprecated API usage
          detection_methods = { "pattern" },
          patterns = { ".git", "Makefile", "package.json" },
        })
      end,
    },
  },
}

-- Search lines with a check for fern buffer
function M.lines()
  run_in_edit_window(function()
    require("fzf-lua").lines()
  end)
end

M.config = function()
  require("fzf-lua").setup({
    files = {
      find_opts = [[-type f]],
    },
    keymap = {
      fzf = {
        ["tab"] = "down",
        ["ctrl-j"] = "down",
        ["shift-tab"] = "up",
        ["ctrl-k"] = "up",
      },
    },
  })
end

return M

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

local function search_snippets()
  run_in_edit_window(function()
    local luasnip = require("luasnip")
    local fzf_lua = require("fzf-lua")
    local snippets = luasnip.available()
    local entries = {}

    for category, snippet_list in pairs(snippets) do
      if type(snippet_list) == "table" then
        for _, snippet in ipairs(snippet_list) do
          local description = ""
          if type(snippet.description) == "table" then
            description = snippet.description[1] or ""
          end
          local entry = string.format("%s - %s (%s) : %s", snippet.trigger, snippet.name or "", category, description)
          table.insert(entries, entry)
        end
      end
    end

    if #entries == 0 then
      vim.notify("No available snippets", vim.log.levels.INFO)
      return
    end

    fzf_lua.fzf_exec(entries, {
      prompt = "Select Snippet> ",
      actions = {
        ["default"] = function(selected)
          if not selected or not selected[1] then
            return
          end
          local trigger = selected[1]:match("^(.-)%s+-")
          if not trigger or trigger == "" then
            return
          end
          vim.api.nvim_put({ trigger }, "c", true, true)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>i", true, true, true), "n", true)
        end,
      },
    })
  end)
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

function M.snippets()
  search_snippets()
end

M.config = function()
  vim.api.nvim_create_user_command("FzfLuaSnipAvailable", function()
    require("plugins.fzf").snippets()
  end, {})

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

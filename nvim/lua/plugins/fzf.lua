local M = {
  "ibhagwan/fzf-lua",

  lazy = true,
  cond = not vim.g.vscode,
  cmd = { "FzfLua" },

  keys = {
    {
      "<leader>p",
      function()
        require("fzf-lua").files()
      end,
      desc = "Search files in the current directory",
    },
    {
      "<leader>g",
      function()
        require("fzf-lua").live_grep()
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
  if vim.bo.filetype == "fern" then
    vim.notify("Cannot use lines picker in fern buffer", vim.log.levels.WARN)
    return
  end

  require("fzf-lua").lines()
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

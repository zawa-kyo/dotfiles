local utils = require("config.utils")

if vim.g.vscode then
  utils.vscode_map("tt", "workbench.action.terminal.toggleTerminal", "Toggle terminal (VSCode)")
end

return {
  {
    "akinsho/toggleterm.nvim",

    cond = not vim.g.vscode,

    keys = {
      {
        "tt",
        ":ToggleTerm direction=horizontal name=desktop<CR>",
        desc = "Toggle terminal (horizontal split)",
      },
    },

    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[\]],
        direction = "float",
      })

      -- Disable mouse when entering terminal mode
      vim.api.nvim_create_autocmd("TermEnter", {
        pattern = "*",
        callback = function()
          vim.opt.mouse = ""
        end,
      })

      -- Re-enable mouse when leaving terminal mode
      vim.api.nvim_create_autocmd("TermLeave", {
        pattern = "*",
        callback = function()
          vim.opt.mouse = "a"
        end,
      })
    end,
  },
}

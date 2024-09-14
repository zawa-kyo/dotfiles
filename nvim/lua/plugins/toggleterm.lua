return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        size = 20,
        open_mapping = [[\]],
        direction = 'float',
      }

      -- Key mapping to open the terminal
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n", "<leader>t", ":ToggleTerm direction=horizontal name=desktop<CR>", opts)

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
  }
}

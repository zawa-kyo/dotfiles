return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      -- ToggleTerm のカスタム設定
      require("toggleterm").setup {
        size = 20,
        open_mapping = [[\]],
        direction = 'float',
      }

      -- FIXME: make terminal effective
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n", "<leader>j", ":ToggleTerm<CR>", opts)
      vim.api.nvim_set_keymap("n", "<leader>t", ":ToggleTerm direction=horizontal name=desktop<CR>", opts)
    end
  }
}

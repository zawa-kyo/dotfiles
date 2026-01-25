return {
  "rachartier/tiny-inline-diagnostic.nvim",

  event = "LspAttach",
  priority = 1000,

  config = function()
    require("tiny-inline-diagnostic").setup()

    -- Disable Neovim's default virtual text diagnostics
    vim.diagnostic.config({ virtual_text = false })

    vim.keymap.set(
      "n",
      "td",
      "<cmd>TinyInlineDiag toggle<cr>",
      { desc = "Toggle inline diagnostics" }
    )
  end,
}

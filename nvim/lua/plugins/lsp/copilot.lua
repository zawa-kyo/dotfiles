-- Copilot support (both core plugin and cmp source bridge)
return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cond = not vim.g.vscode,
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-a>",
            accept_word = false,
            accept_line = false,
          },
        },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    cond = not vim.g.vscode,
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}

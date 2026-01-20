return {
  "smoka7/hop.nvim",

  cond = not vim.g.vscode,
  event = "VeryLazy",

  config = function()
    require("hop").setup()

    local utils = require("config.utils")
    local opts = utils.getOpts
    local keymap = utils.getKeymap
    keymap("n", "J", "<Cmd>HopWord<CR>", opts("Hop to word"))
  end,
}

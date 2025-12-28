return {
  "chrisgrieser/nvim-origami",

  event = { "BufReadPre", "BufNewFile" },
  cond = not vim.g.vscode,

  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,

  config = function()
    require("origami").setup()
  end,
}

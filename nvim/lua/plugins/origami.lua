return {
  "chrisgrieser/nvim-origami",

  event = { "BufReadPre", "BufNewFile" },
  cond = not vim.g.vscode,

  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,

  config = function()
    require("origami").setup({
      useLspFoldsWithTreesitterFallback = {
        enabled = true,
        foldmethodIfNeitherIsAvailable = "indent",
      },
      pauseFoldsOnSearch = true,
      foldtext = {
        enabled = true,
        padding = 2,
        lineCount = {
          template = "󰘖 %d lines",
          hlgroup = "Comment",
        },
        diagnosticsCount = true,
        gitsignsCount = true,
        disableOnFt = { "snacks_picker_input" },
      },
      autoFold = {
        enabled = false,
      },
      foldKeymaps = {
        setup = true,
        closeOnlyOnFirstColumn = false,
        scrollLeftOnCaret = false,
      },
    })
  end,
}

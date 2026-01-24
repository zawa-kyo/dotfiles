return {
  "MagicDuck/grug-far.nvim",

  cond = not vim.g.vscode,

  keys = {
    {
      "rr",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Search and replace in current file",
    },
    {
      "rR",
      function()
        require("grug-far").open()
      end,
      desc = "Search and replace in workspace",
    },
    {
      "r",
      ":'<,'>GrugFarWithin<CR>",
      mode = "v",
      desc = "Search and replace within selection",
    },
  },
}

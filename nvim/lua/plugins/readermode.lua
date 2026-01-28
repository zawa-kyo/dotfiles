return {
  "sarrisv/readermode.nvim",

  event = "VeryLazy",
  cond = not vim.g.vscode,

  keys = {
    {
      "tr",
      function()
        require("readermode").toggle()
      end,
      desc = "Toggle reader mode",
    },
  },
}

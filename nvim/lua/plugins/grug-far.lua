return {
  "MagicDuck/grug-far.nvim",

  cond = not vim.g.vscode,

  keys = {
    {
      "sG",
      "<cmd>GrugFar<CR>",
      desc = "Search and replace (GrugFar)",
    },
  },
}

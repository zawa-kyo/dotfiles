return {
  "atusy/jab.nvim",

  cond = not vim.g.vscode,

  dependencies = {
    { "delphinus/luamigemo", version = "*" },
  },

  keys = {
    {
      "J",
      mode = { "n", "x", "o" },
      function()
        return require("jab").jab_win()
      end,
      expr = true,
      desc = "Search visible text",
    },
    {
      "f",
      mode = { "n", "x", "o" },
      function()
        return require("jab").f()
      end,
      expr = true,
      desc = "Find character forward",
    },
    {
      "F",
      mode = { "n", "x", "o" },
      function()
        return require("jab").F()
      end,
      expr = true,
      desc = "Find character backward",
    },
    {
      "t",
      mode = { "n", "x", "o" },
      function()
        return require("jab").t()
      end,
      expr = true,
      desc = "Move before character forward",
    },
    {
      "T",
      mode = { "n", "x", "o" },
      function()
        return require("jab").T()
      end,
      expr = true,
      desc = "Move after character backward",
    },
  },
}

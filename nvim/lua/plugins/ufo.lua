return {
  "kevinhwang91/nvim-ufo",

  dependencies = {
    "kevinhwang91/promise-async",
  },

  lazy = true,
  event = { "BufReadPre", "BufNewFile", "LspAttach" },
  cond = not vim.g.vscode,

  keys = {
    {
      "zo",
      "zo",
      desc = "Open fold under cursor",
    },
    {
      "zO",
      "zO",
      desc = "Open all folds under cursor",
    },
    {
      "zc",
      "zc",
      desc = "Close fold under cursor",
    },
    {
      "zC",
      "zC",
      desc = "Close all folds under cursor",
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
      desc = "Close all folds",
    },
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
      desc = "Open all folds",
    },
  },

  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require("ufo").setup({
      provider_selector = function(_, filetype)
        if filetype == "markdown" then
          return { "treesitter", "indent" }
        end
        return { "lsp", "indent" }
      end,
    })
  end,
}

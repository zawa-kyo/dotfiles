return {
  "echasnovski/mini.files",
  cond = not vim.g.vscode,

  keys = {
    {
      "-",
      function()
        require("mini.files").open()
      end,
      desc = "Open mini.files",
    },
  },
  config = function()
    require("mini.files").setup({
      content = {
        filter = function()
          return true
        end,
      },
      options = {
        use_as_default_explorer = true,
        use_trash = true,
      },
    })
  end,
}

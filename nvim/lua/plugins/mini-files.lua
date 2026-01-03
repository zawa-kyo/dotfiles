local show_hidden = true

local function filter_hidden(entry)
  return show_hidden or not vim.startswith(entry.name, ".")
end

local function toggle_hidden()
  show_hidden = not show_hidden
  require("mini.files").refresh()
end

return {
  "echasnovski/mini.files",
  cond = not vim.g.vscode,

  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open()
      end,
      desc = "Toggle mini.files",
    },
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
        filter = filter_hidden,
      },
      options = {
        use_as_default_explorer = true,
        use_trash = true,
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        vim.keymap.set(
          "n",
          "e",
          function()
            require("mini.files").go_in()
          end,
          { buffer = args.buf, desc = "Open entry" }
        )
        vim.keymap.set("n", "H", toggle_hidden, { buffer = args.buf, desc = "Toggle hidden files" })
      end,
    })
  end,
}

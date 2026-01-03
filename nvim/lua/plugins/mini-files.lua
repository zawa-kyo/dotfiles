local utils = require("config.utils")

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
    local keymap = utils.getKeymap

    require("mini.files").setup({
      content = {
        filter = filter_hidden,
      },
      mappings = {
        go_in = "l",
        go_in_plus = "<CR>",
      },
      options = {
        use_as_default_explorer = true,
        use_trash = true,
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        keymap("n", "H", toggle_hidden, { buffer = args.buf, desc = "Toggle hidden files" })
      end,
    })
  end,
}

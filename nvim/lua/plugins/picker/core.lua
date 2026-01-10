local picker_keymaps = require("plugins.picker.keymaps")

if vim.g.vscode then
  picker_keymaps.vscode()
end

return {
  "folke/snacks.nvim",

  cond = not vim.g.vscode,
  keys = picker_keymaps.keys,

  opts = {
    picker = {
      actions = {
        toggle_select = function(picker)
          picker.list:select()
        end,
      },
      sources = {
        buffers = {
          win = {
            input = {
              -- Mappings when focus is in the prompt
              keys = {
                ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
                ["x"] = { "bufdelete", mode = { "n" } },
              },
            },
            list = {
              -- Mappings when focus is in the results pane
              keys = {
                ["x"] = "bufdelete",
              },
            },
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<tab>"] = { "list_down", mode = { "i", "n" } },
            ["<s-tab>"] = { "list_up", mode = { "i", "n" } },
            ["<c-x>"] = { "toggle_select", mode = { "i", "n" } },
            ["<c-u>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<c-o>"] = { "toggle_ignored", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<tab>"] = "list_down",
            ["<s-tab>"] = "list_up",
            ["<c-x>"] = "toggle_select",
            ["<c-u>"] = "toggle_hidden",
            ["<c-o>"] = "toggle_ignored",
          },
        },
      },
    },
  },

  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}

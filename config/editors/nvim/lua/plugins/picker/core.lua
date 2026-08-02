local picker_keymaps = require("plugins.picker.keymaps")
local file_visibility = require("config.file-visibility")

if vim.g.vscode then
  picker_keymaps.vscode()
end

-- Synchronize visibility after closing a file-navigation picker.
local function sync_file_visibility(picker)
  file_visibility.sync_navigation(picker.opts)
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
        explorer = {
          on_close = sync_file_visibility,
          win = {
            input = {
              keys = {
                ["<Esc>"] = false,
              },
            },
            list = {
              keys = {
                ["<Esc>"] = false,
              },
            },
          },
        },
        files = {
          on_close = sync_file_visibility,
        },
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
            ["<c-n>"] = { "list_down", mode = { "i", "n" } },
            ["<c-p>"] = { "list_up", mode = { "i", "n" } },
            ["<c-x>"] = { "toggle_select", mode = { "i", "n" } },
            ["<c-u>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<c-o>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["th"] = { "toggle_hidden", mode = "n" },
            ["ti"] = { "toggle_ignored", mode = "n" },
          },
        },
        list = {
          keys = {
            ["<c-n>"] = "list_down",
            ["<c-p>"] = "list_up",
            ["<c-x>"] = "toggle_select",
            ["<c-u>"] = "toggle_hidden",
            ["<c-o>"] = "toggle_ignored",
            ["th"] = "toggle_hidden",
            ["ti"] = "toggle_ignored",
          },
        },
      },
    },
  },

  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}

local file_visibility = require("plugins.files.visibility")

-- Synchronize visibility after closing a file-navigation picker.
local function sync_file_visibility(picker)
  file_visibility.sync_navigation(picker.opts)
end

return {
  actions = {
    toggle_select = function(picker)
      picker.list:select()
    end,
    toggle_navigation_hidden = { "toggle_hidden", sync_file_visibility },
    toggle_navigation_ignored = { "toggle_ignored", sync_file_visibility },
  },
  sources = {
    explorer = {
      on_close = sync_file_visibility,
      win = {
        input = {
          keys = {
            ["<Esc>"] = false,
            ["<a-h>"] = { "toggle_navigation_hidden", mode = { "i", "n" } },
            ["<a-i>"] = { "toggle_navigation_ignored", mode = { "i", "n" } },
            ["<c-u>"] = { "toggle_navigation_hidden", mode = { "i", "n" } },
            ["<c-o>"] = { "toggle_navigation_ignored", mode = { "i", "n" } },
            ["th"] = { "toggle_navigation_hidden", mode = "n" },
            ["ti"] = { "toggle_navigation_ignored", mode = "n" },
          },
        },
        list = {
          keys = {
            ["<Esc>"] = false,
            ["<a-h>"] = "toggle_navigation_hidden",
            ["<a-i>"] = "toggle_navigation_ignored",
            ["<c-u>"] = "toggle_navigation_hidden",
            ["<c-o>"] = "toggle_navigation_ignored",
            ["H"] = "toggle_navigation_hidden",
            ["I"] = "toggle_navigation_ignored",
            ["th"] = "toggle_navigation_hidden",
            ["ti"] = "toggle_navigation_ignored",
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
          keys = {
            ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
            ["x"] = { "bufdelete", mode = { "n" } },
          },
        },
        list = {
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
}

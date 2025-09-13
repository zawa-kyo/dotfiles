-- Unified message/notification manager
-- - Captures all messages (cmdline, LSP, vim.notify) with a unified UI & history.
-- - nvim-notify: toast-style renderer with its own :Notifications window.
-- - Noice: higher-level manager; here we use nvim-notify as its backend.
return {
  "folke/noice.nvim",

  event = "VeryLazy",
  cond = not vim.g.vscode,

  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify", -- used as the notify backend UI
  },

  opts = {
    lsp = {
      -- Use Treesitter/markdown improvements for hover/signature/docs
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- if using nvim-cmp
      },
    },

    presets = {
      -- Put the search cmdline at the bottom
      bottom_search = false,
      -- Stack cmdline and popups
      command_palette = true,
      -- Long messages will be sent to a split
      long_message_to_split = true,
      -- Enables an input dialog for inc-rename.nvim
      inc_rename = false,
      -- Add a border to hover docs and signature help
      lsp_doc_border = true,
    },

    -- Have Noice handle vim.notify and render via nvim-notify
    notify = {
      enabled = true,
      backend = "notify",
    },

    -- Keep regular messages managed & stored in Noice history
    messages = {
      enabled = true,
    },
  },

  -- Keymaps: quick access to history / last / dismiss (+ optional notify history)
  keys = {
    {
      "<leader>nh",
      function()
        require("noice").cmd("history")
      end,
      desc = "Show notification history via Noice",
    },

    {
      "<leader>nH",
      function()
        require("noice").cmd("history", { view = "split" })
      end,
      desc = "Show notification history in split via Noice",
    },

    {
      "<leader>nl",
      function()
        require("noice").cmd("last")
      end,
      desc = "Show last message via Noice",
    },

    -- Normally this keymap doesn’t belong here,
    -- but it’s kept in noice config for clarity:
    -- used to view messages shown before noice starts.
    {
      "<leader>nm",
      "<cmd>messages<CR>",
      desc = "Show messages (via native Vim/Neovim API)",
    },
  },
}

local actions = require("plugins.coding.neotest-config.actions")

return {
  "nvim-neotest/neotest",

  cond = not vim.g.vscode,
  event = {
    "BufReadPre *_test.go",
    "BufReadPre *_test.dart",
    "BufNewFile *_test.go",
    "BufNewFile *_test.dart",
  },
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "fredrikaverpil/neotest-golang",
    "mrcjkb/rustaceanvim",
    "sidlatau/neotest-dart",
  },
  keys = {
    {
      "Xtn",
      actions.run_nearest,
      desc = "Run nearest test",
    },
    {
      "Xtf",
      actions.run_file,
      desc = "Run tests in current file",
    },
    {
      "Xta",
      actions.run_workspace,
      desc = "Run tests in current working directory",
    },
    {
      "Xtl",
      actions.run_last,
      desc = "Run last test",
    },
    {
      "Xts",
      actions.stop_nearest,
      desc = "Stop nearest test",
    },
    {
      "rto",
      actions.show_output,
      desc = "Show test output",
    },
    {
      "rts",
      actions.toggle_summary,
      desc = "Show test summary",
    },
  },

  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-golang")({
          runner = "go",
        }),
        require("neotest-dart")({
          command = "flutter",
          use_lsp = true,
        }),
        require("rustaceanvim.neotest"),
      },
    })

    -- TODO: Add nvim-dap and the Go debug adapter before mapping test debugging.
  end,
}

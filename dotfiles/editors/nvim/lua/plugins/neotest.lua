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
    "sidlatau/neotest-dart",
  },
  keys = {
    {
      "Xtn",
      function()
        require("neotest").run.run()
      end,
      desc = "Run nearest test",
    },
    {
      "Xtf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run tests in current file",
    },
    {
      "Xta",
      function()
        require("neotest").run.run(vim.fn.getcwd())
      end,
      desc = "Run tests in current working directory",
    },
    {
      "Xtl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run last test",
    },
    {
      "Xts",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop nearest test",
    },
    {
      "rt",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "Show test output",
    },
    {
      "rT",
      function()
        require("neotest").summary.toggle()
      end,
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
      },
    })

    -- TODO: Add nvim-dap and the Go debug adapter before mapping test debugging.
  end,
}

return {
  "y3owk1n/undo-glow.nvim",

  cond = not vim.g.vscode,
  event = "VeryLazy",

  keys = {
    {
      "u",
      function()
        require("undo-glow").undo()
      end,
      mode = "n",
      desc = "Undo with glow",
      noremap = true,
    },
    {
      "U",
      function()
        require("undo-glow").redo()
      end,
      mode = "n",
      desc = "Redo with glow",
      noremap = true,
    },
    {
      "p",
      function()
        require("undo-glow").paste_below()
      end,
      mode = "n",
      desc = "Paste below with glow",
      noremap = true,
    },
    {
      "P",
      function()
        require("undo-glow").paste_above()
      end,
      mode = "n",
      desc = "Paste above with glow",
      noremap = true,
    },
    {
      "n",
      function()
        require("undo-glow").search_next({
          animation = {
            animation_type = "strobe",
          },
        })
      end,
      mode = "n",
      desc = "Search next with glow",
      noremap = true,
    },
    {
      "N",
      function()
        require("undo-glow").search_prev({
          animation = {
            animation_type = "strobe",
          },
        })
      end,
      mode = "n",
      desc = "Search prev with glow",
      noremap = true,
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "Highlight when yanking (copying) text",
      callback = function()
        require("undo-glow").yank()
      end,
    })
  end,

  config = function()
    require("undo-glow").setup({
      animation = {
        enabled = true,
        duration = 300,
      },
    })
  end,
}

return {
  "echasnovski/mini.clue",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  config = function()
    local miniclue = require("mini.clue")
    local gen_clues = miniclue.gen_clues

    local triggers = {
      { mode = { "x", "o" }, keys = "a" },
      { mode = { "n", "x" }, keys = "g" },
      { mode = { "x", "o" }, keys = "i" },
      { mode = "n",          keys = "m" },
      { mode = { "n", "x" }, keys = "s" },
      { mode = "n",          keys = "t" },
      { mode = { "x", "o" }, keys = "o" },
      { mode = "n",          keys = "r" },
      { mode = "n",          keys = "X" },
      { mode = { "n", "x" }, keys = "z" },
      { mode = "n",          keys = "[" },
      { mode = "n",          keys = "]" },
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' },
      { mode = { "i", "c" }, keys = "<C-r>" },
      { mode = "n",          keys = "<C-w>" },
      { mode = "i",          keys = "<C-x>" },
      { mode = { "n", "x" }, keys = "<Leader>" },
    }

    local clues = {
      gen_clues.square_brackets(),
      gen_clues.builtin_completion(),
      gen_clues.g(),
      gen_clues.marks(),
      gen_clues.registers({ show_contents = true }),
      gen_clues.windows({ submode_resize = true, submode_move = true }),
      gen_clues.z(),
    }

    miniclue.setup({
      triggers = triggers,
      clues = clues,
      window = {
        delay = 500, -- ms
        config = {
          border = "rounded",
        },
      },
    })
  end,
}

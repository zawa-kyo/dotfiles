return {
  "echasnovski/mini.ai",

  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.extra" },

  config = function()
    local ai = require("mini.ai")
    local gen_ai_spec = require("mini.extra").gen_ai_spec
    local treesitter = ai.gen_spec.treesitter

    local custom_textobjects = {
      a = treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      b = treesitter({ a = "@block.outer", i = "@block.inner" }),
      c = treesitter({ a = "@class.outer", i = "@class.inner" }),
      d = treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
      f = treesitter({ a = "@function.outer", i = "@function.inner" }),
      k = treesitter({ a = "@comment.outer", i = "@comment.inner" }),
      l = treesitter({ a = "@loop.outer", i = "@loop.inner" }),
      s = treesitter({ a = "@statement.outer", i = "@statement.inner" }),
      t = treesitter({ a = "@tag.outer", i = "@tag.inner" }),
      B = gen_ai_spec.buffer(),
      D = gen_ai_spec.diagnostic(),
      I = gen_ai_spec.indent(),
      L = gen_ai_spec.line(),
      N = gen_ai_spec.number(),
      J = { { "()%d%d%d%d%-%d%d%-%d%d()", "()%d%d%d%d%/%d%d%/%d%d()" } },
    }
    ai.setup({
      custom_textobjects = custom_textobjects,
    })
  end,
}

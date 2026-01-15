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
      c = treesitter({ a = "@class.outer", i = "@class.inner" }),
      f = treesitter({ a = "@function.outer", i = "@function.inner" }),
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

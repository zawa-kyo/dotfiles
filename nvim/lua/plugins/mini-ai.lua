return {
  "echasnovski/mini.ai",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.extra" },
  config = function()
    local gen_ai_spec = require("mini.extra").gen_ai_spec

    require("mini.ai").setup({
      custom_textobjects = {
        B = gen_ai_spec.buffer(),
        D = gen_ai_spec.diagnostic(),
        I = gen_ai_spec.indent(),
        L = gen_ai_spec.line(),
        N = gen_ai_spec.number(),
        J = { { "()%d%d%d%d%-%d%d%-%d%d()", "()%d%d%d%d%/%d%d%/%d%d()" } },
      },
    })
  end,
}

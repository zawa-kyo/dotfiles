return {
  "kevinhwang91/nvim-hlslens",

  cond = not vim.g.vscode,
  event = "VeryLazy",

  opts = {},

  config = function(_, opts)
    local hlslens = require("hlslens")
    hlslens.setup(opts)

    local keymap_opts = { noremap = true, silent = true }
    vim.keymap.set("n", "*", [[*<Cmd>lua require("hlslens").start()<CR>]], keymap_opts)
    vim.keymap.set("n", "#", [[#<Cmd>lua require("hlslens").start()<CR>]], keymap_opts)
    vim.keymap.set("n", "g*", [[g*<Cmd>lua require("hlslens").start()<CR>]], keymap_opts)
    vim.keymap.set("n", "g#", [[g#<Cmd>lua require("hlslens").start()<CR>]], keymap_opts)
  end,
}

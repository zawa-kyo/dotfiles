return {
  "s-show/extend_word_motion.nvim",

  event = "VeryLazy",
  cond = not vim.g.vscode,

  dependencies = {
    "sirasagi62/tinysegmenter.nvim",
  },

  opts = {},
}

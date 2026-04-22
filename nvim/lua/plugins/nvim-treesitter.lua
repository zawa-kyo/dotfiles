return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",

  event = {
    "BufNewFile",
    "BufRead",
  },

  -- Load in vscode to enable textobjects
  -- cond = not vim.g.vscode,

  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    "nvim-treesitter/nvim-treesitter-context",
  },
  build = ":TSUpdate",
  config = function()
    local function use_builtin_parser(lang)
      local paths = vim.api.nvim_get_runtime_file(("parser/%s.so"):format(lang), true)
      local builtin = paths[#paths]
      if builtin and builtin:match("/lib/nvim/parser/") then
        vim.treesitter.language.add(lang, { path = builtin })
      end
    end

    -- nvim-treesitter main currently ships a vim parser older than Neovim 0.12's bundled one.
    use_builtin_parser("vim")
  end,
}

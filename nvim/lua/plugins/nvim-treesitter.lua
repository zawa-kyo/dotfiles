return {
  "nvim-treesitter/nvim-treesitter",

  event = {
    "BufNewFile",
    "BufRead",
  },

  -- Load in vscode to enable textobjects
  -- cond = not vim.g.vscode,

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
  },
  build = ":TSUpdate",
  config = function()
    local query = require("vim.treesitter.query")

    local non_filetype_match_injection_language_aliases = {
      ex = "elixir",
      pl = "perl",
      sh = "bash",
      ts = "typescript",
      uxn = "uxntal",
    }

    local directive_opts = vim.fn.has("nvim-0.10") == 1 and { force = true, all = false } or true

    local function capture_node(match, capture_id)
      local node = match[capture_id]
      if type(node) == "table" then
        return node[1]
      end
      return node
    end

    local function parser_from_markdown_info_string(injection_alias)
      local match = vim.filetype.match({ filename = "a." .. injection_alias })
      return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
    end

    -- Neovim 0.12 can pass a capture list here; older nvim-treesitter code assumes a single TSNode.
    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = capture_node(match, pred[2])
      if not node then
        return
      end
      local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
      metadata["injection.language"] = parser_from_markdown_info_string(injection_alias)
    end, directive_opts)

    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "markdown",
        "markdown_inline",
        "python",
        "java",
        "dart",
        "rust",
      },
      highlight = {
        enable = true,
      },
    })
  end,
}

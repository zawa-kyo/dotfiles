return {
  "echasnovski/mini.pairs",

  cond = not vim.g.vscode,
  event = "InsertEnter",

  config = function()
    require("mini.pairs").setup()

    local utils = require("config.utils")
    local opts = utils.getOpts
    local keymap = utils.getKeymap

    local smart_quote = function(quote)
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local left = col == 0 and "" or line:sub(col, col)

      if left == "" or left:match("%s") then
        return quote .. quote .. "<Left>"
      end

      return quote
    end

    keymap("i", '"', function()
      return smart_quote('"')
    end, opts("Smart quote", nil, nil, true))

    keymap("i", "'", function()
      return smart_quote("'")
    end, opts("Smart quote", nil, nil, true))

    keymap("i", "`", function()
      return smart_quote("`")
    end, opts("Smart quote", nil, nil, true))
  end,
}

return {
  "ixru/nvim-markdown",

  ft = { "markdown", "markdown.mdx" },
  cond = not vim.g.vscode,
  init = function()
    -- Disable all default keymaps to avoid conflicts with user mappings.
    vim.g.vim_markdown_no_default_key_mappings = 1
  end,

  config = function()
    local utils = require("config.utils")
    local opts = utils.getOpts
    local keymap = utils.getKeymap
    local group = vim.api.nvim_create_augroup("nvim_markdown_custom_keymaps", { clear = true })

    local function set_markdown_keymaps(bufnr)
      local buffer_opts = { buffer = bufnr }

      -- Normal Mode
      keymap(
        "n",
        "o",
        "<Plug>Markdown_NewLineBelow",
        vim.tbl_extend("force", opts("Insert new line below"), buffer_opts)
      )
      keymap(
        "n",
        "<CR>",
        "<Plug>Markdown_NewLineBelow",
        vim.tbl_extend("force", opts("Insert new line below"), buffer_opts)
      )

      -- Insert Mode
      keymap("i", "<CR>", function()
        require("markdown").new_line_below()
      end, vim.tbl_extend("force", opts("Insert new line below"), buffer_opts))
    end

    if vim.tbl_contains({ "markdown", "markdown.mdx" }, vim.bo.filetype) then
      set_markdown_keymaps(0)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "markdown", "markdown.mdx" },
      callback = function(args)
        set_markdown_keymaps(args.buf)
      end,
    })
  end,
}

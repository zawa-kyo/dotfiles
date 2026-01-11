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

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "markdown", "markdown.mdx" },
      callback = function()
        local buffer_opts = { buffer = true }

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
        keymap(
          "n",
          "]]",
          "<Plug>Markdown_MoveToNextHeader",
          vim.tbl_extend("force", opts("Go to next header"), buffer_opts)
        )
        keymap(
          "n",
          "[[",
          "<Plug>Markdown_MoveToPreviousHeader",
          vim.tbl_extend("force", opts("Go to previous header"), buffer_opts)
        )
        keymap(
          "n",
          "][",
          "<Plug>Markdown_MoveToNextSiblingHeader",
          vim.tbl_extend("force", opts("Go to next sibling header"), buffer_opts)
        )
        keymap(
          "n",
          "[]",
          "<Plug>Markdown_MoveToPreviousSiblingHeader",
          vim.tbl_extend("force", opts("Go to previous sibling header"), buffer_opts)
        )
        keymap(
          "n",
          "]c",
          "<Plug>Markdown_MoveToCurHeader",
          vim.tbl_extend("force", opts("Go to current header"), buffer_opts)
        )
        keymap(
          "n",
          "]u",
          "<Plug>Markdown_MoveToParentHeader",
          vim.tbl_extend("force", opts("Go to parent header"), buffer_opts)
        )

        -- Insert Mode
        keymap("i", "<CR>", function()
          require("markdown").new_line_below()
        end, vim.tbl_extend("force", opts("Insert new line below"), buffer_opts))
      end,
    })
  end,
}

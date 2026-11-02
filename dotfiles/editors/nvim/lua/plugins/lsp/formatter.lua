return function()
  local formatting = require("null-ls").builtins.formatting

  return {
    -- Match VS Code's prettier-vscode experience
    formatting.prettierd.with({
      filetypes = { "markdown", "mdx" },
    }),
  }
end

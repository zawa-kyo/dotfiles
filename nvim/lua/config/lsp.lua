-- Common LSP config shared across servers (and flutter-tools)
-- Keep one startup path; keymaps assume LSP is attached.
local M = {}

-- Shared LSP capabilities
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Shared on_attach: buffer-local keymaps and behaviors
function M.on_attach(_, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
  end

  map("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format the current file with LSP")

  map("n", "K", vim.lsp.buf.hover, "Show hover information")
  map("n", "gr", vim.lsp.buf.references, "Show references")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
  map("n", "rn", vim.lsp.buf.rename, "Rename the symbol")
  map("n", "ga", vim.lsp.buf.code_action, "Show available code actions")
  map("n", "ge", vim.diagnostic.open_float, "Show diagnostics")
  map("n", "g]", vim.diagnostic.goto_next, "Go to next diagnostic issue")
  map("n", "g[", vim.diagnostic.goto_prev, "Go to previous diagnostic issue")
end

return M

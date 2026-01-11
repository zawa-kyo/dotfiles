-- Common LSP config shared across servers (and flutter-tools)
-- Keep one startup path; keymaps assume LSP is attached.
local M = {}

local utils = require("config.utils")

-- Shared LSP capabilities
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

local format_on_save_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })

-- Shared on_attach: buffer-local keymaps and behaviors
function M.on_attach(_, bufnr)
  local keymap = utils.getKeymap

  local function map(mode, lhs, rhs, desc)
    keymap(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
  end

  local format_capable = #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" }) > 0
  if format_capable then
    vim.api.nvim_clear_autocmds({ group = format_on_save_group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = format_on_save_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
      end,
      desc = "Format buffer with LSP on save",
    })
  end

  -- g: go
  -- TODO: Use snacks
  map("n", "gr", vim.lsp.buf.references, "Show references")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")

  -- m: modify
  map("n", "mr", vim.lsp.buf.rename, "Rename the symbol")
  map("n", "mf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format the current file with LSP")

  -- S: show
  map("n", "K", vim.lsp.buf.hover, "Show hover information")
  map("n", "ri", vim.lsp.buf.hover, "Show hover information")
  map("n", "ra", vim.lsp.buf.code_action, "Show code action list")
  map("n", "rd", vim.diagnostic.open_float, "Show diagnostics")
end

return M

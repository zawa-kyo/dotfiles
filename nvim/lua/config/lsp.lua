-- Common LSP config shared across servers (and flutter-tools)
-- Keep one startup path; keymaps assume LSP is attached.
local M = {}

local utils = require("config.utils")
local picker = require("snacks").picker

-- Shared LSP capabilities
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Remove Neovim LSP default keymaps to avoid mini.clue noise.
do
  local lsp_defaults = { "gra", "gri", "grm", "grr", "grt", "grn" }
  for _, lhs in ipairs(lsp_defaults) do
    pcall(vim.keymap.del, "n", lhs)
    pcall(vim.keymap.del, "x", lhs)
  end
end

local format_on_save_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })

-- Shared on_attach: buffer-local keymaps and behaviors
function M.on_attach(_, bufnr)
  local keymap = utils.getKeymap

  --- Set a buffer-local LSP keymap with default options and optional overrides.
  local function map(mode, lhs, rhs, desc, opts)
    local options = { buffer = bufnr, silent = true, noremap = true, desc = desc }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    keymap(mode, lhs, rhs, options)
  end

  local format_capable = #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" }) > 0
  if format_capable then
    vim.api.nvim_clear_autocmds({ group = format_on_save_group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = format_on_save_group,
      buffer = bufnr,
      callback = function()
        -- Merge auto-save/write + format into a single undo block when possible.
        pcall(vim.cmd, "silent! undojoin")

        vim.lsp.buf.format({ bufnr = bufnr, async = false })
      end,
      desc = "Format buffer with LSP on save",
    })
  end

  -- g: go
  map("n", "gd", picker.lsp_definitions, "Go to definition")
  map("n", "gD", picker.lsp_declarations, "Go to declaration")
  map("n", "gr", picker.lsp_references, "Go to References", { nowait = true })
  map("n", "gi", picker.lsp_implementations, "Go to implementation")
  map("n", "gt", picker.lsp_type_definitions, "Go to type definition")
  map("n", "gc", picker.lsp_incoming_calls, "Calls incoming")
  map("n", "gC", picker.lsp_outgoing_calls, "Calls outgoing")

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

local M = {}

---Return whether this Neovim build supports the 0.12 native LSP completion API.
---@return boolean
function M.has_native_lsp_completion()
  return vim.fn.has("nvim-0.12") == 1
    and vim.lsp
    and vim.lsp.completion
    and type(vim.lsp.completion.enable) == "function"
end

---Build the global completeopt value.
---Use conservative defaults on older Neovim versions and enable 0.12-specific
---popup features only when the native completion API is available.
---@return string[]
function M.completeopt()
  local options = { "menu", "menuone", "noselect" }

  if M.has_native_lsp_completion() then
    table.insert(options, "fuzzy")
    table.insert(options, "popup")
  end

  return options
end

---Enable Neovim's native LSP completion hooks for a buffer when available.
---This only prepares the built-in completion path during the migration. The
---actual interactive experience still comes from nvim-cmp until the remaining
---keymaps and completion sources are switched over.
---@param client vim.lsp.Client
---@param bufnr integer
function M.enable_lsp_completion(client, bufnr)
  if not M.has_native_lsp_completion() then
    return
  end

  if not client:supports_method("textDocument/completion") then
    return
  end

  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.lsp.completion.enable(true, client.id, bufnr, {
    autotrigger = false,
  })
end

return M

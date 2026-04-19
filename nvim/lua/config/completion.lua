local M = {}
local native_completion_group = vim.api.nvim_create_augroup("NativeLspCompletion", { clear = false })

local function feedkey(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", true)
end

local function get_luasnip()
  local ok, luasnip = pcall(require, "luasnip")
  if ok then
    return luasnip
  end
end

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
---completion features only when the native completion API is available.
---@return string[]
function M.completeopt()
  local options = { "menu", "menuone", "noselect" }

  if M.has_native_lsp_completion() then
    table.insert(options, "fuzzy")
    -- Neovim 0.12.1 + current nvim-treesitter can crash while rendering
    -- markdown fenced-code docs in completion preview popups. Keep the native
    -- completion menu, but leave preview popups disabled until upstream fixes
    -- the conceal_line/query_predicates interaction.
  end

  return options
end

---Enable Neovim's native LSP completion hooks for a buffer when available.
---Enable native completion for the attached LSP client and current buffer.
---Neovim recommends InsertCharPre + vim.lsp.completion.get() when you want
---completion on every keypress instead of only on server trigger characters.
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

  vim.api.nvim_clear_autocmds({ group = native_completion_group, buffer = bufnr })
  vim.api.nvim_create_autocmd("InsertCharPre", {
    group = native_completion_group,
    buffer = bufnr,
    callback = function()
      if vim.fn.pumvisible() == 1 then
        return
      end

      -- Follow :help lsp-autocompletion so prefixes like "con" can complete to
      -- "console", even when the server does not advertise letter triggers.
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.lsp.completion.get()
        end
      end)
    end,
    desc = "Trigger native LSP completion on every typed character",
  })
end

---Expand or jump within a LuaSnip snippet, otherwise indent the current line.
function M.expand_or_jump_or_indent()
  local luasnip = get_luasnip()
  if luasnip and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
    return
  end

  feedkey("<C-t>")
end

---Jump backwards within a LuaSnip snippet, otherwise outdent the current line.
function M.jump_back_or_outdent()
  local luasnip = get_luasnip()
  if luasnip and luasnip.jumpable(-1) then
    luasnip.jump(-1)
    return
  end

  feedkey("<C-d>")
end

---Select the next completion item, or request completion when the popup is closed.
function M.select_next()
  if vim.fn.pumvisible() == 1 then
    feedkey("<C-n>")
    return
  end

  if M.has_native_lsp_completion() then
    vim.lsp.completion.get()
    return
  end

  feedkey("<C-n>")
end

---Select the previous completion item, or request completion when the popup is closed.
function M.select_prev()
  if vim.fn.pumvisible() == 1 then
    feedkey("<C-p>")
    return
  end

  if M.has_native_lsp_completion() then
    vim.lsp.completion.get()
    return
  end

  feedkey("<C-p>")
end

---Accept the selected completion item so LSP side effects are applied.
---Fall back to inserting a newline when the completion popup is closed.
function M.confirm()
  if vim.fn.pumvisible() == 1 then
    feedkey("<C-y>")
    return
  end

  feedkey("<CR>")
end

return M

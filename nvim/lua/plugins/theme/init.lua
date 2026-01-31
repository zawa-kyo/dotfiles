local function set_snacks_diff_hl()
  local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if ok then
      return hl
    end
    return {}
  end

  local function strip_bg(hl)
    return {
      fg = hl.fg,
      bg = nil,
      bold = hl.bold,
      italic = hl.italic,
      underline = hl.underline,
    }
  end

  local add = get_hl("DiffAdd")
  local del = get_hl("DiffDelete")
  local change = get_hl("DiffChange")
  local comment = get_hl("Comment")
  local warn = get_hl("DiagnosticVirtualTextWarn")

  vim.api.nvim_set_hl(0, "SnacksDiffHeader", strip_bg(comment))
  vim.api.nvim_set_hl(0, "SnacksDiffAdd", strip_bg(add))
  vim.api.nvim_set_hl(0, "SnacksDiffDelete", strip_bg(del))
  vim.api.nvim_set_hl(0, "SnacksDiffContext", strip_bg(change))
  vim.api.nvim_set_hl(0, "SnacksDiffConflict", strip_bg(warn))
  vim.api.nvim_set_hl(0, "SnacksDiffAddLineNr", strip_bg(add))
  vim.api.nvim_set_hl(0, "SnacksDiffDeleteLineNr", strip_bg(del))
  vim.api.nvim_set_hl(0, "SnacksDiffContextLineNr", strip_bg(change))
  vim.api.nvim_set_hl(0, "SnacksDiffConflictLineNr", strip_bg(warn))
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_snacks_diff_hl,
})

return {
  require("plugins.theme.catppuccin"),
  require("plugins.theme.evergarden"),
  require("plugins.theme.nord"),
  require("plugins.theme.nordfox"),
  require("plugins.theme.nordic"),
  require("plugins.theme.onedark"),
  require("plugins.theme.tokyonight"),
}

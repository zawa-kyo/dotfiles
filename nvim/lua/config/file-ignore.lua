local M = {}

M.exact_names = {
  ".DS_Store",
}

function M.is_ignored(name)
  for _, ignored in ipairs(M.exact_names) do
    if name == ignored then
      return true
    end
  end

  return false
end

function M.fern_exclude()
  local patterns = {}
  for _, name in ipairs(M.exact_names) do
    local escaped = vim.fn.escape(name, [[\.^$~[]*]])
    table.insert(patterns, "^" .. escaped .. "$")
  end

  return table.concat(patterns, "\\|")
end

return M

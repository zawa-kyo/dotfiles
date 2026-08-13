local M = {}

M.names = {
  ".git",
  ".DS_Store",
}

local excluded_names = {}
for _, name in ipairs(M.names) do
  excluded_names[name] = true
end

-- Return whether a file or directory name is always excluded.
function M.contains(name)
  return excluded_names[name] == true
end

return M

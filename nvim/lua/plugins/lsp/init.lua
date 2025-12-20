-- Aggregate LSP-related plugin specs split into focused modules for clarity
local sections = {
  require("plugins.lsp.core"),
  require("plugins.lsp.copilot"),
  require("plugins.lsp.completion"),
  require("plugins.lsp.formatting"),
}

local spec = {}

for _, group in ipairs(sections) do
  vim.list_extend(spec, group)
end

return spec

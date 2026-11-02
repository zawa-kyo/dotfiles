return function()
  local null_ls = require("null-ls")

  return {
    null_ls.builtins.diagnostics.textlint.with({
      runtime_condition = function(params)
        if vim.fn.executable("textlint") == 1 then
          return true
        end

        local utils = require("null-ls.utils")
        local root = utils.get_vcs_root() or utils.get_root()
        for dir in vim.fs.parents(params.bufname) do
          if vim.fn.executable(vim.fs.joinpath(dir, "node_modules", ".bin", "textlint")) == 1 then
            return true
          end
          if dir == root then
            break
          end
        end
        return false
      end,
    }),
  }
end

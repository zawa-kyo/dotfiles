return {
  "Bekaboo/dropbar.nvim",

  cond = not vim.g.vscode,
  event = { "BufReadPre", "BufNewFile" },

  keys = {
    {
      "tb", -- Toggle breadcrumbs
      "<Cmd>DropbarToggle<CR>",
      desc = "Toggle breadcrumbs"
    },

  },

  -- TODO: Review and refine dropbar settings later.
  config = function()
    local dropbar = require("dropbar")
    local configs = require("dropbar.configs")
    local utils = require("dropbar.utils")
    local default_enable = configs.opts.bar.enable

    local function is_enabled(win)
      local ok, value = pcall(vim.api.nvim_win_get_var, win, "dropbar_enabled")
      if not ok then
        return false
      end
      return value ~= false
    end

    dropbar.setup({
      bar = {
        enable = function(buf, win, info)
          if not is_enabled(win) then
            return false
          end
          return configs.eval(default_enable, buf, win, info)
        end,
      },
    })

    vim.api.nvim_create_user_command("DropbarToggle", function()
      local win = vim.api.nvim_get_current_win()
      local enabled = not is_enabled(win)
      vim.api.nvim_win_set_var(win, "dropbar_enabled", enabled)
      if enabled then
        utils.bar.attach(vim.api.nvim_win_get_buf(win), win)
        utils.bar.exec("update", { win = win })
        return
      end

      utils.bar.exec("del", { win = win })
      vim.wo[win].winbar = ""
    end, {})
  end,
}

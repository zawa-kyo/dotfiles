return {
  "Pocco81/auto-save.nvim",

  cond = not vim.g.vscode,
  event = { "InsertLeave", "TextChanged" },

  config = function()
    require("auto-save").setup({
      enabled = true,
      debounce_delay = 200,
      trigger_events = { "InsertLeave", "TextChanged" },
      execution_message = {
        message = "",
        dim = 0,
        cleaning_interval = 0,
      },

      condition = function(buf)
        if not vim.api.nvim_buf_is_valid(buf) then
          return false
        end

        if not vim.api.nvim_buf_is_loaded(buf) then
          return false
        end

        if vim.bo[buf].buftype ~= "" then
          return false
        end

        if not vim.bo[buf].modifiable then
          return false
        end

        return true
      end,
    })
  end,
}

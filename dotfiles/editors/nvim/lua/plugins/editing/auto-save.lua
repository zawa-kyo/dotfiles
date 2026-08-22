return {
  "Pocco81/auto-save.nvim",

  cond = not vim.g.vscode,
  event = { "InsertLeave" },

  config = function()
    local utils = require("config.utils")
    local keymap = utils.getKeymap
    local opts = utils.getOpts

    if not vim.g.vscode then
      keymap("n", "ta", "<Cmd>ASToggle<CR>", opts("Toggle auto-save"))
    end

    local autosave = require("auto-save")
    autosave.setup({
      enabled = true,
      debounce_delay = 200,
      trigger_events = { "InsertLeave" },
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

    -- Recreate autocommands after setup since the plugin enables itself on load.
    autosave.off()
    autosave.on()
  end,
}

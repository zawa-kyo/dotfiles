local mode_colors = {
  CommandMode = "#f5c359",
  InsertMode = "#4db5bd",
  ReplaceMode = "#c75c6a",
  SelectMode = "#769ff0",
  VisualMode = "#769ff0",
}

-- Apply the mode palette after each colorscheme change.
local function set_mode_highlights()
  for group, color in pairs(mode_colors) do
    vim.api.nvim_set_hl(0, group, { fg = color })
  end
end

return {
  "mawkler/modicator.nvim",

  cond = not vim.g.vscode,
  event = "VeryLazy",

  init = function()
    vim.o.cursorline = true
    vim.o.number = true
    vim.o.termguicolors = true
  end,

  config = function()
    set_mode_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("ModicatorColorScheme", { clear = true }),
      callback = set_mode_highlights,
    })

    require("modicator").setup({
      integration = {
        lualine = {
          enabled = false,
        },
      },
    })
  end,
}

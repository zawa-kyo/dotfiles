return {
  "nvim-lualine/lualine.nvim",

  cond = not vim.g.vscode,
  event = "VimEnter",

  dependencies = {
    "DaikyXendo/nvim-material-icon",
  },

  config = function()
    local function setup_lualine()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },

        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end

    local group = vim.api.nvim_create_augroup("LualineColorScheme", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = function()
        setup_lualine()
        require("lualine").refresh()
      end,
    })

    setup_lualine()
  end,
}

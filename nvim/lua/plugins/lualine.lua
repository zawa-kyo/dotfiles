return {
  "nvim-lualine/lualine.nvim",

  cond = not vim.g.vscode,
  event = "VimEnter",

  dependencies = {
    "DaikyXendo/nvim-material-icon",
  },

  config = function()
    local ignore_lsp_list = {
      ["null-ls"] = true,
      ["null_ls"] = true,
    }

    local function lsp_clients()
      local clients = {}
      if vim.lsp.get_clients then
        clients = vim.lsp.get_clients({ bufnr = 0 })
      else
        clients = vim.lsp.get_active_clients({ bufnr = 0 })
      end

      local names = {}
      for _, client in ipairs(clients) do
        if not ignore_lsp_list[client.name] then
          table.insert(names, client.name)
        end
      end

      if #names == 0 then
        return "No LSP"
      end

      return table.concat(names, ", ")
    end

    local function setup_lualine()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },

        sections = {
          lualine_a = { "branch" },
          lualine_b = { "filename" },
          lualine_c = { "diff" },
          lualine_x = { "diagnostics" },
          lualine_y = {
            { lsp_clients, icon = " " },
          },
          lualine_z = { "filetype" },
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

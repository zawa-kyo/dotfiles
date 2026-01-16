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

    local function filename_icon_parts()
      local devicons = require("nvim-web-devicons")
      local name = vim.api.nvim_buf_get_name(0)
      if name == "" then
        local icon, color = devicons.get_icon_color("", "", { default = true })
        return icon, color
      end

      local filename = vim.fn.fnamemodify(name, ":t")
      local ext = vim.fn.fnamemodify(name, ":e")
      local icon, color = devicons.get_icon_color(filename, ext, { default = true })
      return icon, color
    end

    local function filename_icon_text()
      local icon = filename_icon_parts()
      return icon
    end

    local function filename_icon_color()
      local _, color = filename_icon_parts()
      return { fg = color }
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
          lualine_b = {
            {
              filename_icon_text,
              color = filename_icon_color,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              icon = "",
              separator = "",
              padding = { left = 0, right = 1 },
            },
          },
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
          lualine_x = {},
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

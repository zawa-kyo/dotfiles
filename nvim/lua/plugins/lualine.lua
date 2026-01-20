return {
  "nvim-lualine/lualine.nvim",

  cond = not vim.g.vscode,
  event = "VimEnter",

  dependencies = {
    "DaikyXendo/nvim-material-icon",
  },

  config = function()
    local lualine_visible = true
    local laststatus_visible = vim.o.laststatus ~= 0

    -- Build an LSP client label, excluding names from the given list.
    local function lsp_clients(ignore_list)
      local ignore_lookup = {}
      for _, name in ipairs(ignore_list) do
        ignore_lookup[name] = true
      end

      return function()
        local clients = {}
        if vim.lsp.get_clients then
          clients = vim.lsp.get_clients({ bufnr = 0 })
        else
          clients = vim.lsp.get_active_clients({ bufnr = 0 })
        end

        local names = {}
        for _, client in ipairs(clients) do
          if not ignore_lookup[client.name] then
            table.insert(names, client.name)
          end
        end

        if #names == 0 then
          return "No LSP"
        end

        return table.concat(names, ", ")
      end
    end

    -- Resolve devicon and color for the current buffer.
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

    -- Return the current buffer icon text.
    local function filename_icon_text()
      local icon = filename_icon_parts()
      return icon
    end

    -- Return the current buffer icon color.
    local function filename_icon_color()
      local _, color = filename_icon_parts()
      return { fg = color }
    end

    -- Build a shortened yank register preview.
    local function yank_register(max_length)
      return function()
        local yank_content = vim.fn.getreg('"')
        yank_content = yank_content:gsub("\n", " ")
        yank_content = yank_content:gsub("^%s+", "")
        if #yank_content > max_length then
          yank_content = string.sub(yank_content, 1, max_length) .. "..."
        end
        return yank_content ~= "" and yank_content or "EMPTY"
      end
    end

    -- Return the current tab index as n/N for compact display.
    local function tab_ratio()
      local current = vim.fn.tabpagenr()
      local total = vim.fn.tabpagenr("$")
      return string.format("%d/%d", current, total)
    end

    -- Configure lualine sections and options.
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
          lualine_x = {
            { yank_register(12), icon = "" },
            "diagnostics",
            {
              lsp_clients({ "null-ls", "null_ls" }),
              icon = " ",
            },
          },
          lualine_y = {
            { tab_ratio, icon = "󱦞" },
          },
          lualine_z = {},
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

    vim.keymap.set("n", "ts", function()
      local ok, lualine = pcall(require, "lualine")
      if not ok then
        return
      end

      lualine_visible = not lualine_visible
      lualine.hide({ place = { "statusline" }, unhide = lualine_visible })

      laststatus_visible = not laststatus_visible
      vim.o.laststatus = laststatus_visible and 3 or 0
    end, { desc = "Toggle statusline" })
  end,
}

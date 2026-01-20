return {
  "goolord/alpha-nvim",

  lazy = true,
  event = "VimEnter",
  cond = not vim.g.vscode,

  dependencies = {
    "echasnovski/mini.icons",
    "nvim-lua/plenary.nvim",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Footer function to display plugins, date, version, and startup time
    local function footer()
      local stats = require("lazy").stats()
      local total_plugins = stats.count
      local startup_time = string.format("%.2f ms", stats.startuptime)
      local date = os.date("%Y-%m-%d")
      local time = os.date("%H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "v" .. version.major .. "." .. version.minor .. "." .. version.patch

      local parts = {
        { icon = "", text = date },
        { icon = "", text = time },
        { icon = "󰭖", text = startup_time },
        { icon = "󱐮", text = total_plugins .. " plugins" },
        { icon = "", text = nvim_version_info },
      }

      local segments = {}
      for _, part in ipairs(parts) do
        table.insert(segments, string.format("%s %s", part.icon, part.text))
      end

      return table.concat(segments, "  ")
    end

    local function refresh_footer()
      dashboard.section.footer.val = footer()
      pcall(vim.cmd, "AlphaRedraw")
    end

    -- Set shortcuts
    dashboard.section.buttons.val = {
      dashboard.button("n", "  Create New File", ":ene <BAR> startinsert <CR>"),
      dashboard.button("W", "󰱼  Find Texts", ":lua require('snacks').picker.grep()<CR>"),
      dashboard.button("f", "󰥨  Find Files", ":lua require('snacks').picker.files()<CR>"),
      dashboard.button("F", "  Show Recent Files", ":lua require('snacks').picker.recent()<CR>"),
      dashboard.button("e", "󰉖  Snacks Explorer", ":lua require('snacks').explorer.open()<CR>"),
      dashboard.button("E", "󰉖  Mini Explorer", ":lua require('mini.files').open()<CR>"),
      dashboard.button("l", "󰒲  Open Lazy.nvim", ":Lazy<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    -- Set footer
    refresh_footer()

    -- Set footer color (for example, 'Type' is a built-in highlight group)
    vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#9CBF86", bold = true })
    dashboard.section.footer.opts.hl = "DashboardFooter"

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[
            autocmd FileType alpha setlocal nofoldenable
        ]])

    local function refresh_footer_when_ready()
      local tries = 0
      local max_tries = 20
      local interval_ms = 50

      local function tick()
        tries = tries + 1
        if require("lazy").stats().startuptime > 0 or tries >= max_tries then
          refresh_footer()
          return
        end
        vim.defer_fn(tick, interval_ms)
      end

      vim.defer_fn(tick, interval_ms)
    end

    -- Update footer after lazy.nvim computes startuptime
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = refresh_footer_when_ready,
      once = true,
    })

    local function should_start_alpha_for_directory()
      if vim.fn.argc() ~= 1 then
        return false
      end
      local target = vim.fn.argv(0)
      return target ~= nil and target ~= "" and vim.fn.isdirectory(target) == 1
    end

    if should_start_alpha_for_directory() then
      alpha.start(false, dashboard.config)
    end
  end,
}

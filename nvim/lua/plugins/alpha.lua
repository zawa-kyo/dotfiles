return {
    'goolord/alpha-nvim',
    dependencies = {
        'echasnovski/mini.icons',
        'nvim-lua/plenary.nvim'
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

        -- Footer function to display plugins, date, and version
        local function footer()
            -- Use Lazy's stats function to get the number of plugins
            local total_plugins = require("lazy").stats().count
            local datetime = os.date(" %Y-%m-%d  %H:%M:%S")
            local version = vim.version()
            local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

            return datetime .. "  󱐮 " .. total_plugins .. " plugins" .. nvim_version_info
        end

        -- Set shortcuts
        dashboard.section.buttons.val = {
            dashboard.button("<Space>b", "  Fern", ":Fern . -drawer -toggle<CR>"),
            dashboard.button("<Space>p", "󰥨  Find file", ":FzfLua files<CR>"),
            dashboard.button("<Space>g", "󰱼  Find text", ":FzfLua live_grep<CR>"),
            dashboard.button("r", "  Recent file", ":FzfLua oldfiles<CR>"),
            dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("s", "  Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        -- Set footer
        dashboard.section.footer.val = footer()

        -- Set footer color (for example, 'Type' is a built-in highlight group)
        vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#9CBF86", bold = true })
        dashboard.section.footer.opts.hl = "DashboardFooter"

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[
            autocmd FileType alpha setlocal nofoldenable
        ]])
    end
}

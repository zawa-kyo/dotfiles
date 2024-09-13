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


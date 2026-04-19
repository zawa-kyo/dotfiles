local blink_highlight_group = vim.api.nvim_create_augroup("BlinkCmpHighlights", { clear = true })

---Link blink.cmp highlight groups to theme-native groups.
---@return nil
local function set_blink_highlights()
  local links = {
    BlinkCmpMenu = "Pmenu",
    BlinkCmpMenuBorder = "FloatBorder",
    BlinkCmpMenuSelection = "PmenuSel",
    BlinkCmpScrollBarThumb = "PmenuThumb",
    BlinkCmpScrollBarGutter = "PmenuSbar",
    BlinkCmpLabel = "Pmenu",
    BlinkCmpLabelDetail = "Comment",
    BlinkCmpLabelDescription = "Comment",
    BlinkCmpKind = "Special",
    BlinkCmpSource = "Comment",
    BlinkCmpDoc = "Pmenu",
    BlinkCmpDocBorder = "FloatBorder",
    BlinkCmpDocSeparator = "PmenuSbar",
    BlinkCmpSignatureHelp = "NormalFloat",
    BlinkCmpSignatureHelpBorder = "FloatBorder",
  }

  for group, link in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = link, default = false })
  end
end

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    cond = not vim.g.vscode,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        trigger = {
          show_on_keyword = true,
          show_on_backspace_in_keyword = true,
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          border = "rounded",
          auto_show = true,
          winhighlight = table.concat({
            "Normal:BlinkCmpMenu",
            "FloatBorder:BlinkCmpMenuBorder",
            "CursorLine:BlinkCmpMenuSelection",
            "Search:None",
          }, ","),
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          update_delay_ms = 50,
          treesitter_highlighting = false,
          window = {
            border = "rounded",
            winhighlight = table.concat({
              "Normal:BlinkCmpDoc",
              "FloatBorder:BlinkCmpDocBorder",
              "EndOfBuffer:BlinkCmpDoc",
            }, ","),
            direction_priority = {
              menu_north = { "e", "w", "n", "s" },
              menu_south = { "e", "w", "s", "n" },
            },
          },
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "inherit" },
        completion = {
          menu = { auto_show = true },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = table.concat({
            "Normal:BlinkCmpSignatureHelp",
            "FloatBorder:BlinkCmpSignatureHelpBorder",
          }, ","),
        },
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      set_blink_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = blink_highlight_group,
        callback = set_blink_highlights,
        desc = "Relink blink.cmp highlights after colorscheme changes",
      })
      require("blink.cmp").setup(opts)
    end,
  },
}

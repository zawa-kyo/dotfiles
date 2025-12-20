-- nvim-cmp configuration and related completion sources
return {
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter",
    cond = not vim.g.vscode,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        local text = vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
        return col ~= 0 and text:match("^%s*$") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "copilot" },
          { name = "nvim_lsp_signature_help" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        experimental = {
          ghost_text = false,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            preset = "codicons",
            maxwidth = 50,
            symbol_map = { Copilot = "" },
          }),
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
          { name = "nvim_lsp_document_symbol" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          {
            name = "buffer",
            option = {
              keyword_pattern = [[\k\+]],
            },
          },
          { name = "nvim_lsp_document_symbol" },
        },
      })
    end,
  },
}

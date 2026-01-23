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
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      local has_words_before = function()
        if vim.bo[0].buftype == "prompt" then
          return false
        end
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line, col = cursor[1], cursor[2]
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
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end),
          ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end),
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

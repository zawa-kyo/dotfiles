return {
  "L3MON4D3/LuaSnip",

  dependencies = { "rafamadriz/friendly-snippets" },
  version = "v2.*",
  build = "make install_jsregexp",
  event = "InsertEnter",

  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
    })
  end,
}

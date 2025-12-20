local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("note", {
    t({ ">[!NOTE]", ">" }),
    i(1),
  }),
  s("tip", {
    t({ ">[!TIP]", ">" }),
    i(1),
  }),
  s("important", {
    t({ ">[!IMPORTANT]", ">" }),
    i(1),
  }),
  s("warning", {
    t({ ">[!WARNING]", ">" }),
    i(1),
  }),
  s("caution", {
    t({ ">[!CAUTION]", ">" }),
    i(1),
  }),
}

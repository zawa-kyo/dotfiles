local M = {
  "monaqa/dial.nvim",

  lazy = true,
  keys = {
    {
      "<C-a>",
      function()
        require("dial.map").manipulate("increment", "normal")
      end,
      desc = "Increment the number under the cursor",
      mode = "n",
    },
    {
      "<C-x>",
      function()
        require("dial.map").manipulate("decrement", "normal")
      end,
      desc = "Decrement the number under the cursor",
      mode = "n",
    },
    {
      "<C-a>",
      function()
        require("dial.map").manipulate("increment", "visual")
      end,
      desc = "Increment the number under the cursor",
      mode = "v",
    },
    {
      "<C-x>",
      function()
        require("dial.map").manipulate("decrement", "visual")
      end,
      desc = "Decrement the number under the cursor",
      mode = "v",
    },
  },
}

function M.config()
  local dial = require("dial.config")
  local augend = require("dial.augend")

  dial.augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
      augend.constant.alias.bool,
    },
  })
end

return M

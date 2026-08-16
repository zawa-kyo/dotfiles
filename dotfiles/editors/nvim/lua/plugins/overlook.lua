return {
  "WilliamHsieh/overlook.nvim",

  keys = {
    {
      "rD",
      function()
        require("overlook.api").peek_definition()
      end,
      desc = "Peek definition with Overlook",
    },
  },
}

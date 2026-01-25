return {
  "j-hui/fidget.nvim",

  event = "LspAttach",
  cond = not vim.g.vscode,

  config = function()
    require("fidget").setup({
      notification = {
        window = {
          -- Background color opacity
          winblend = 0,
        },
      },
    })
  end,
}

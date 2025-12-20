return {
  "cohama/lexima.vim",
  cond = not vim.g.vscode,
  event = "InsertEnter",
  init = function()
    -- Disable default space rules before lexima loads so we can define our own
    vim.g.lexima_enable_space_rules = 0
  end,
  config = function()
    local custom_space_rules = [[
      call lexima#add_rule({'char': '<Space>', 'at': '(\%#)', 'input_after': '<Space>'})
      call lexima#add_rule({'char': ')', 'at': '\%# )', 'leave': 2})
      call lexima#add_rule({'char': '<BS>', 'at': '( \%# )', 'delete': 1})
      call lexima#add_rule({'char': '<Space>', 'at': '{\%#}', 'input_after': '<Space>'})
      call lexima#add_rule({'char': '}', 'at': '\%# }', 'leave': 2})
      call lexima#add_rule({'char': '<BS>', 'at': '{ \%# }', 'delete': 1})
    ]]

    vim.cmd(custom_space_rules)
  end,
}

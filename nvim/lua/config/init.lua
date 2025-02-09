require("config.core")
require("config.keymaps")
require("config.options")
require("config.lazy")

-- Load keymaps after lazy plugins
require("config.plugin-keymaps")

-- Load colorscheme
vim.opt.termguicolors = true
vim.cmd [[colorscheme nord]]

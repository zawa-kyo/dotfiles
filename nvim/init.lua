-- Speed up Lua module loading (Neovim 0.9+)
if vim.loader then vim.loader.enable() end

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.Loaded_netrwPlugin = 1

require("config")

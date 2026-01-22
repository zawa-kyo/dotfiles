-- Speed up Lua module loading (Neovim 0.9+)
if vim.loader then vim.loader.enable() end

-- Load the main configuration
require("config")

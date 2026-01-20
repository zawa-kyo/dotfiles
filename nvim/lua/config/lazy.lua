-- Bootstrap for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration and plugins
require("lazy").setup("plugins", {
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "gzip", -- Handles editing compressed .gz files transparently
        "man", -- Provides :Man command to read UNIX man pages inside Vim/Neovim
        "rplugin", -- Legacy remote plugin host support; not needed with Lua plugins
        "tarPlugin", -- Handles browsing and editing tar archives
        "tohtml", -- Converts a buffer into HTML for exporting syntax-highlighted code
        "tutor", -- Built-in interactive Vim tutor (:Tutor command)
        "zipPlugin", -- Handles browsing and editing zip archives
      },
    },
  },
})

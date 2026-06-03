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
        "editorconfig", -- Applies EditorConfig settings to buffers
        "gzip", -- Handles editing compressed .gz files transparently
        "man", -- Provides :Man command to read UNIX man pages inside Vim/Neovim
        "matchit", -- Extends % matching for more text objects
        "matchparen", -- Highlights matching parentheses
        "netrw", -- Built-in file explorer and network browsing
        "netrwPlugin", -- Netrw plugin that wires up commands and mappings
        "osc52", -- Clipboard integration over OSC52 terminals
        "rplugin", -- Legacy remote plugin host support; not needed with Lua plugins
        "spellfile", -- Downloads spellfiles for new dictionaries
        "tarPlugin", -- Handles browsing and editing tar archives
        "tohtml", -- Converts a buffer into HTML for exporting syntax-highlighted code
        "tutor", -- Built-in interactive Vim tutor (:Tutor command)
        "zipPlugin", -- Handles browsing and editing zip archives
      },
    },
  },
})

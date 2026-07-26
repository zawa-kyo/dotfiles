--------------------
-- Utils
--------------------

local utils = require("config.utils")
local opts = utils.getOpts
local keymap = utils.getKeymap

-- Remap space to leader key
keymap("", "<Space>", "<Nop>", opts("Nop"))
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------
-- Docs
--------------------

-- Modes:
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',
--
-- Prefix design (movement/navigation):
--   <leader>w … Window action path (split/resize/equalize/close)
--   <leader>t … Tab action path (new/split/close)
--   <leader>b … Buffer action path (list/delete/reload)
--   g*        … “Jump” semantics (jumplist/marks) — keep gp/gP
--   [j / ]j   … Jumplist movement
--   ] / [     … “Next / Previous” cycle UI (window/buffer/tab/diagnostic/quickfix/loclist/…)
--   n/N       … Keep default search repeat in Normal mode
--   Jab       … f/F/t/T behavior and J visible-text search are handled in jab.nvim config

require("config.keymaps.common")
require("config.keymaps.diagnostics")
require("config.keymaps.editing")
require("config.keymaps.escape")
require("config.keymaps.markdown")

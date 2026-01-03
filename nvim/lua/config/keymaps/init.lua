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
--   <leader>w … Window ops (move/split/resize/equalize/close)
--   <leader>t … Tab ops (new/move/close)
--   <leader>b … Buffer ops (next/prev/list/delete)
--   g*        … “Jump” semantics (jumplist/marks) — keep gp/gP
--   ] / [     … “Next / Previous” common UI (diagnostic/quickfix/loclist/…)
--   n/N       … Keep default search repeat (unless overridden elsewhere)
--   Flash     … f/F/t/T behavior is handled in flash.nvim config

require("config.keymaps.common")
require("config.keymaps.diagnostics")
require("config.keymaps.editing")
require("config.keymaps.escape")

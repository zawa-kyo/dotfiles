local options = {
  -- Use a dark colorscheme background
  background = "dark",
  -- Avoid overwriting existing files when writing
  backup = false,
  -- Do not create backups for temp directories
  backupskip = { "/tmp/*", "/private/tmp/*" },
  -- Sync system clipboard with unnamed register
  clipboard = "unnamedplus",
  -- Make command-line two rows tall
  cmdheight = 2,
  -- Completion UI should show menu even with one match
  completeopt = { "menuone", "noselect" },
  -- Hide concealed text entirely (useful for Markdown)
  conceallevel = 0,
  -- Highlight the current line for easier tracking
  cursorline = true,
  -- Preferred file encoding
  encoding = "utf-8",
  -- Convert tabs to spaces
  expandtab = true,
  -- Encoding written to files
  fileencoding = "utf-8",
  -- Force Neovim to append a trailing newline when writing files
  fixendofline = true,
  -- Start with most folds open
  foldlevel = 99,
  -- GUI font setting for GUIs like Neovide
  guifont = "monospace:h17",
  -- Highlight search matches
  hlsearch = true,
  -- Ignore case when searching by default
  ignorecase = true,
  -- Enable mouse support
  mouse = "a",
  -- Show absolute line numbers
  number = true,
  -- Width of the number column
  numberwidth = 4,
  -- Popup menu height limit
  pumheight = 10,
  -- Do not show relative numbers
  relativenumber = false,
  -- Keep cursor away from top/bottom edges
  scrolloff = 8,
  -- Use Zsh for :! commands / terminal
  shell = "zsh",
  -- Number of spaces for each indent step
  shiftwidth = 2,
  -- Hide -- INSERT -- indicator (statusline handles it)
  showmode = false,
  -- Always show the tabline
  showtabline = 2,
  -- Keep cursor away from left/right edges
  sidescrolloff = 8,
  -- Always show the sign column
  signcolumn = "yes",
  -- Smart-case search (case-sensitive only when needed)
  smartcase = true,
  -- Maintain indentation on new lines
  smartindent = true,
  -- New splits open below the current window
  splitbelow = true,
  -- New splits open to the right
  splitright = true,
  -- Disable swap files
  swapfile = false,
  -- Display width for a literal <Tab>
  tabstop = 2,
  -- Enable truecolor support
  termguicolors = true,
  -- Mappings timeout length in ms
  timeoutlen = 300,
  -- Show file title in the window titlebar
  title = true,
  -- Persist undo history
  undofile = true,
  -- Faster CursorHold/diagnostic updates
  updatetime = 300,
  -- Use popup menu for :wildmenu completion
  wildoptions = "pum",
  -- Transparent floating window backgrounds
  winblend = 0,
  -- Enable line wrapping
  wrap = true,
  -- Do not keep extra backup files
  writebackup = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Move left and right across lines
vim.cmd("set whichwrap=b,s,h,l,<,>,[,],~")

-- Note: Avoid auto-changing CWD on BufEnter to reduce conflicts

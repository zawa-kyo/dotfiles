local options = {
  background = "dark",
  backup = false,
  backupskip = { "/tmp/*", "/private/tmp/*" },
  clipboard = "unnamedplus",
  cmdheight = 2,
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,
  cursorline = true,
  encoding = "utf-8",
  expandtab = true,
  fileencoding = "utf-8",
  guifont = "monospace:h17",
  hlsearch = true,
  ignorecase = true,
  mouse = "a",
  number = true,
  numberwidth = 4,
  pumheight = 10,
  relativenumber = false,
  scrolloff = 8,
  shell = "zsh",
  shiftwidth = 2,
  showmode = false,
  showtabline = 2,
  sidescrolloff = 8,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 300,
  title = true,
  undofile = true,
  updatetime = 300,
  wildoptions = "pum",
  winblend = 0,
  wrap = false,
  writebackup = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Move left and right across lines
vim.cmd("set whichwrap=b,s,h,l,<,>,[,],~")

-- Note: Avoid auto-changing CWD on BufEnter to reduce conflicts

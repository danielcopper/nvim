local opt = vim.opt

-- Leader keys (set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Appearance
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Whitespace and separators
-- TODO: use theme.icons.
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", extends = "›", precedes = "‹", nbsp = "␣" }

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Behavior
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.confirm = true

-- Completion
opt.completeopt = "menu,menuone"
opt.pumheight = 10

-- Formatting (jcroqlnt: see :help fo-table)
opt.formatoptions = "jcroqlnt"

-- Spell check
opt.spelllang = { "en", "de" }

-- Folding (for nvim-ufo)
opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Cross-platform: Windows shell config
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  opt.shell = "pwsh"
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  opt.shellquote = ""
  opt.shellxquote = ""
end

-- Smooth scrolling (Neovim 0.10+)
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

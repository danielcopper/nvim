-- Core Neovim Options

local opt = vim.opt

-- Leader keys (set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw (oil.nvim replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Appearance
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.confirm = true
opt.hidden = true

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Folding
opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Formatting (jcroqlnt: see :help fo-table)
opt.formatoptions = "jcroqlnt"

-- Spell check
opt.spelllang = { "en", "de" }

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

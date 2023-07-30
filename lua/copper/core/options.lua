vim.opt.clipboard = 'unnamedplus' -- allows neovim to access the system clipboard
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = 'utf-8'

-- vim.g.python3_host_prog = '~/AppData/Local/Programs/Python/Python311/python.exe'

vim.g.mapleader = ' '

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

vim.lsp.codelens = true
vim.opt.hidden = true -- required to keep open hidden buffers

-- general indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- no line wrapping when text flows over screen
vim.opt.wrap = false

-- no vim backups but undo tree has a long history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

-- should improve response time
vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "123"

-- no ~ on gui
-- vim.opt.fillchars = { eob = " " }

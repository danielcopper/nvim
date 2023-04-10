vim.g.python3_host_prog = '~/AppData/Local/Programs/Python/Python311/python.exe'


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
vim.opt.undodir = os.getenv('TEMP') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
-- no idea what this is doing
-- vim.opt.isfname:append("@-@")

-- should improve response time
vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "123"

vim.g.mapleader = ' '

-- no ~ on gui
-- vim.opt.fillchars = { eob = " " }

-- vim.opt.showmode = false -- dont show mode since we have a statusline

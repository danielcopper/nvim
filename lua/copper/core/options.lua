local opt = vim.opt

vim.g.mapleader = " "

opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = 'utf-8'

opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Enable highlighting of the current line

vim.lsp.codelens = true
opt.hidden = true -- required to keep open hidden buffers

-- TODO: They don't apply anymore??
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4
opt.shiftwidth = 4 -- indent size
opt.expandtab = true -- use spaces instead of tabs

opt.smartindent = true -- Insert indents automatically

opt.wrap = false -- no line wrapping when text flows over screen

-- no vim backups but undo tree has a long history
opt.swapfile = false
opt.backup = false
-- TODO: Check how lazyvim does this platform agnostic
-- opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- opt.undodir = os.getenv("appdata") .. "/Local/nvim-data/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true -- True color support

opt.scrolloff = 8 -- minimum visible lines at the bottom or top
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time

opt.cursorline = true -- Enable highlighting of the current line
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.inccommand = "nosplit" -- preview incremental substitute
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.spelllang = { "en", "de" }
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

opt.updatetime = 50 -- should improve response time


-- vim.opt.colorcolumn = "123"
-- no ~ on gui
vim.opt.fillchars = { eob = " " }

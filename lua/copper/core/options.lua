local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

vim.lsp.codelens = true

opt.number = true         -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true     -- Enable highlighting of the current line

opt.splitbelow = true
opt.splitright = true

opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.conceallevel = 0          -- so that `` is visible in markdown files
opt.fileencoding = "utf-8"

opt.hidden = true    -- required to keep open hidden buffers

opt.expandtab = true -- use spaces instead of tabs
opt.tabstop = 4      -- Number of spaces neovim inserts when tabbing
opt.shiftwidth = 4   -- indent size when using <, > or 'cindent' for indentation
opt.softtabstop = 4

opt.smartindent = true    -- Insert indents automatically

opt.wrap = false          -- no line wrapping when text flows over screen
opt.virtualedit = "block" -- in v-block mode allows to select cells that have no text

-- no vim backups but undo tree has a long history
opt.swapfile = false
opt.backup = false
opt.undofile = true
---@diagnostic disable-next-line: assign-type-mismatch
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

opt.hlsearch = false
opt.incsearch = true
-- TODO: find a way so that the window showing the prieview adjusts in size
opt.inccommand = "split" -- open a hsplit showing all the "upcoming" changes

opt.termguicolors = true -- Full color support - enable 24bit color support, also ignores the terminal color scheme

opt.scrolloff = 8        -- minimum visible lines at the bottom or top
opt.sidescrolloff = 8    -- Columns of context
opt.signcolumn = "yes"   -- Always show the signcolumn, otherwise it would shift the text each time

opt.ignorecase = true    -- Ignore case for command tab complete
opt.smartcase = true     -- Don't ignore case with capitals
opt.list = true          -- Show some invisible characters (tabs...
opt.mouse = "a"          -- Enable mouse mode
opt.spelllang = { "en", "de" }

opt.updatetime = 50 -- should improve response time

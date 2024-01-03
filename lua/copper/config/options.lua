vim.copper_config = vim.copper_config or {}

local options = {
  opt = {
    backup = false,            -- controls whether a backup file is created before writing a new version of the file
    clipboard = "unnamedplus", -- allows neovim to sync with the system clipboard
    -- completeopt = "menu,menuone,noselect", -- defines the completion menu behaviour
    completeopt = "menu,menuone,preview,noselect",
    conceallevel = 0,    -- so that `` is visible in markdown files
    confirm = true,      -- Confirm to save changes before exiting modified buffer
    cursorline = true,   -- Enable highlighting of the current line
    expandtab = true,    -- Use spaces instead of tabs
    fileencoding = "utf-8",
    foldcolumn = "0",    -- width of the foldcolumn
    foldenable = true,
    foldlevel = 99,      -- A foldlevel of 0 means all folds are closed
    foldlevelstart = 99, -- Don't close any folds at the start
    -- TODO: Find a good solution for this - I only want to show a symbol if a fold is open or closed, no numbers -> check lazyvim as a first step
    -- foldtext = "v:lua.require'copper.config'.ui.foldtext()",
    formatoptions = "jcroqlnt", -- This sets various formatting options in Neovim. Each letter represents a specific behavior
    grepformat = "%f:%l:%c:%m", -- This defines the format that Neovim expects for the output of the
    grepprg = "rg --vimgrep",   -- This sets the program Neovim uses for the :grep command
    hidden = true,              -- required to keep open hidden buffers
    hlsearch = false,
    ignorecase = true,          -- Ignore case for command tab complete
    inccommand = "split",       -- open a hsplit showing all the "upcoming" changes
    incsearch = true,
    laststatus = 3,             -- global statusline
    list = true,                -- Show some invisible characters (tabs...
    mouse = "a",                -- Enable mouse mode
    number = true,              -- Print line number
    pumblend = 0,               -- Popub blend
    pumheight = 10,             -- Maximum number of entries in a popup
    relativenumber = true,      -- Relative line numbers
    scrolloff = 8,              -- minimum visible lines at the bottom or top
    sessionoptions = {
      "buffers",
      "curdir",
      "tabpages",
      "winsize",
      "help",
      "globals",
      "skiprtp",
      "folds"
    },                                                             -- which aspects of your environment are saved when you create a session
    shiftround = true,                                             -- Round indent
    shiftwidth = 4,                                                -- Size of an indent
    showmode = false,                                              -- Dont show mode since we have a statusline
    sidescrolloff = 8,                                             -- Columns of context
    signcolumn = "yes",                                            -- Always show the signcolumn, otherwise it would shift the text each time
    smartcase = true,                                              -- Don't ignore case with capitals
    smartindent = true,                                            -- Insert indents automatically
    softtabstop = 4,
    spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add", -- change the path to spellfile (TODO: needs testing)
    spelllang = { "en", "de" },
    splitbelow = true,                                             -- Put new windows below current
    splitkeep = "screen",                                          -- Keep the same relative cursor position when splitting
    splitright = true,                                             -- Put new windows right of current
    swapfile = false,                                              -- no vim backups but undo tree has a long history
    tabstop = 4,                                                   -- Number of spaces neovim inserts when tabbing
    termguicolors = true,                                          -- Full color support - enable 24bit color support, also ignores the terminal color scheme
    timeout = true,
    timeoutlen = 300,                                              -- sets the time in milliseconds to wait for a mapped sequence to complete (keymaps)
    undodir = vim.fn.stdpath("data") .. "/undodir",                -- specifies the directory where undo files are stored.
    undofile = true,                                               -- enables the creation of undo files
    undolevels = 10000,                                            -- specifies the maximum number of changes that can be undone
    updatetime = 500,                                              -- Save swap file and trigger CursorHold. This sets the time in milliseconds to wait before triggering the CursorHold event and updating the swap file. A shorter updatetime makes Neovim more responsive in triggering certain autocommands and updating swap files, but it might increase disk write frequency.
    virtualedit = "block",                                         -- Allow cursor to move where there is no text in visual block mode
    wildmode = "longest:full,full",                                -- Command-line completion mode
    winminwidth = 5,                                               -- Minimum window width
    wrap = false,                                                  -- Disable line wrap
    fillchars = {                                                  -- used to set characters for filling the status lines, vertical splits, etc., when they are otherwise empty.
      foldopen = "",
      foldclose = "",
      -- fold = "⸱",
      fold = " ",
      foldsep = " ",
      diff = "╱",
      eob = " ",
    },
  },
  g = {
    mapleader = " ",
    maplocalleader = "\\",
    markdown_recommended_style = 0, -- Fix markdown indentation settings
  },
  lsp = {
    codelens = true,
  },
  copper_config = { -- My own settings table
    borders = "none",
    colorscheme = "monet",
    transparent = false,
  }
}

-- NOTE: somehow not recognized in the options table without vim.opt.
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- control which messages Neovim shows or suppresses

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

-- TODO: Find my own solution for this in conjunction with foldtext
-- if vim.fn.has("nvim-0.9.0") == 1 then
--   vim.opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
-- end

-- Apply all the options
for scope, table in pairs(options) do
  for setting, value in pairs(table) do
    vim[scope][setting] = value
  end
end

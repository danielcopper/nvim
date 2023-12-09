local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  defaults = {
    lazy = true,
  },
  spec = {
    -- Some core plugins
    -- NOTE: Maybe remove (or move to where they are a dependency)
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },
    { "MunifTanjim/nui.nvim" },
    -- TODO: Test if it is useful
    -- textDocument/onTypeFormatting
    { "yioneko/nvim-type-fmt" },
    { import = "copper.plugins.coding" },
    { import = "copper.plugins.editor" },
    { import = "copper.plugins.lsp" },
    { import = "copper.plugins.debugging" },
    { import = "copper.plugins.ui" },
  },
  ui = {
    border = "rounded",
  },
  install = {
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "catppuccin", "rose-pine", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- We get this in the statusline
  },
  change_detection = {
    notify = false, -- don't notify about config changes
  },
  performance = {
    rtp = {
      disabled_plugins = {
        -- TODO: Check what these do
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Neovim Configuration
-- Structure: init.lua (bootstrap) | lua/config/ (options, keymaps, autocmds) | lua/plugins/ (plugin specs)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core config (options sets leader keys)
require("config.options")

-- Setup plugins
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { enabled = true, notify = false },
  ui = { border = "rounded" },
})

-- Load keymaps and autocmds
require("config.keymaps")
require("config.autocmds")

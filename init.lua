-- Neovim Configuration
-- Structure: init.lua (bootstrap) | lua/config/ (options, keymaps, autocmds) | lua/plugins/ (plugin specs)

-- Load environment variables from .env file
local function load_env()
  local env_file = vim.fn.stdpath("config") .. "/.env"
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      -- Skip empty lines and comments
      if line:match("^%s*$") == nil and line:match("^%s*#") == nil then
        local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
        if key and value then
          -- Remove quotes if present
          value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
          vim.env[key] = value
        end
      end
    end
  end
end
load_env()

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

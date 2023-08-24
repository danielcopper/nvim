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

-- Set up defaults and load core options and settings first
-- TODO: Turn this into a spec
require("copper.config")


require("lazy").setup({
    spec = {
        { import = "copper.plugins" },
    },
    install = {
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "catppuccin", "tokyonight", "habamax" },
    },
    checker = {
        -- automatically check for plugin updates
        enabled = true,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

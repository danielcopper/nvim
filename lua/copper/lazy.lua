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
        { import = "copper.plugins" },
        { import = "copper.plugins.lsp"}
    },
    install = {
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "catppuccin", "tokyonight", "habamax" },
    },
    checker = {
        enabled = true, -- automatically check for plugin updates
    },
    change_detection = {
        notify = false, -- don't notify about config changes
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

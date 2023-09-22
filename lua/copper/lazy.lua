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
        cond = function()
            if vim.g.vscode then
                return false
            else
                return true
            end
        end,
    },
    spec = {
        { import = "copper.plugins" },
        { import = "copper.plugins.lsp" },
        -- { import = "copper.plugins.extras.vscode" }, -- Loads vscode specific configurations for plugins
    },
    install = {
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "catppuccin", "tokyonight", "habamax" },
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
                "gzip",
                "matchit",
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

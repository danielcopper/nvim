return {
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- TODO: Maybe exchange this
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals' } },
        keys = {
            { '<leader>pr', function() require('persistence').load() end,                desc = 'Restore Session' },
            { '<leader>pl', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
            -- {
            --     "<leader>qd",
            --     function() require("persistence").stop() end,
            --     desc =
            --     "Don't Save Current Session"
            -- },
        },
    },

    -- dependency for other plugins
    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    { 'MunifTanjim/nui.nvim', lazy = true},
}

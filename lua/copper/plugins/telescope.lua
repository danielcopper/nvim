return {
    'nvim-telescope/telescope.nvim',
    opts = {
        defaults = {
            dynamic_preview_title = true, -- Shows the whole filepath above the preview
        }
    },
    keys = {
        vim.keymap.set('n', '<leader>pf', function() require('telescope.builtin').find_files() end,
            { desc = 'Open Telescope find files' }),
        vim.keymap.set('n', '<leader>td', function() require('telescope.builtin').diagnostics() end,
            { desc = 'Lists diagnostics for currently open buffers in Telescope' }),
        vim.keymap.set('n', '<leader>ps', function() require('telescope.builtin').live_grep() end,
            { desc = 'Telescope Grep String Search' }),
        vim.keymap.set('n', '<leader>km', function() require('telescope.builtin').keymaps() end,
            { desc = 'Lists normal mode keymappings in Telescope' }),
    }
}

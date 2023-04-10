return {
    'nvim-telescope/telescope.nvim',
    keys = {
        vim.keymap.set('n', '<leader>pf', function() require('telescope.builtin').find_files() end,
            { desc = 'Open Telescope find files' }),
        vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end,
            { desc = 'Telescope goto References' }),
        vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions() end,
            { desc = 'Telescope goto Definitions' }),
        vim.keymap.set('n', 'gtd', function() require('telescope.builtin').lsp_type_definitions() end,
            { desc = 'Telescope goto Type Definition' }),
        vim.keymap.set('n', 'gi', function() require('telescope.builtin').lsp_implementations() end,
            { desc = 'Telescope goto Implementation' }),
        vim.keymap.set('n', '<leader>ps', function() require('telescope.builtin').live_grep() end,
            { desc = 'Telescope Grep String Search' }),
        vim.keymap.set('n', '<leader>km', function() require('telescope.builtin').keymaps() end,
            { desc = 'Lists normal mode keymappings' }),
    }
}

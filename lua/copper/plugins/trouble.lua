-- Diagnostics helper
return {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = {
        position = 'right',
        icons = true,
        use_diagnostic_signs = true,
    },
    keys = {
        vim.keymap.set('n', '<leader>to', '<cmd>Trouble<cr>',
            { desc = 'Open Workspace Diagnostics (Trouble)' }),
        vim.keymap.set('n', '<leader>tf', '<cmd>TroubleToggle document_diagnostics<cr>',
            { desc = 'Toggle Document Diagnostics (Trouble)' }),
        vim.keymap.set('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
            { desc = 'Toggle Workspace Diagnostics (Trouble)' }),
    }
}

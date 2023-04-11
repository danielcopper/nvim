-- Diagnostics helper
return {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
        vim.keymap.set('n', '<leader>tf', '<cmd>TroubleToggle document_diagnostics<cr>',
            { desc = 'Document Diagnostics (Trouble)' }),
        vim.keymap.set('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
            { desc = 'Workspace Diagnostics (Trouble)' }),
    }
}

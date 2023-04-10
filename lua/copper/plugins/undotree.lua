return {
    'mbbill/undotree',
    lazy = false,
    keys = {
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Show Undo History' }),
    }
}

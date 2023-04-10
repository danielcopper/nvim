return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        ensure_installed = { 'bash', 'c', 'html', 'javascript', 'json', 'lua', 'luadoc', 'luap', 'markdown',
            'markdown_inline', 'python', 'query', 'regex', 'tsx', 'typescript', 'vim', 'yaml', },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<C-space>',
                node_incremental = '<C-space>',
                scope_incremental = '<nop>',
                node_decremental = '<bs>',
            },
        },
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end,
}

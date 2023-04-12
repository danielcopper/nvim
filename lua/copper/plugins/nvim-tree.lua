return {
    'nvim-tree/nvim-tree.lua',
    opts = {
        git = {
            enable = true,
            ignore = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
            timeout = 5000,
        },
        view = {
            width = 36,
        },
        renderer = {
            full_name = true,
            highlight_opened_files = 'all',
            root_folder_label = ':~:s?$?/..?',
            indent_width = 2,
        },
        hijack_unnamed_buffer_when_opening = true,
    },
    keys = {
        vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeFocus<CR>'),
        vim.keymap.set('n', '<leader>er', '<Cmd>NvimTreeRefresh<CR>'),
    }
}

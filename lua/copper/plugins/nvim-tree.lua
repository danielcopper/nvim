return {
    'nvim-tree/nvim-tree.lua',
    lazy = false, -- opens the tree on nvim startup without a autocmd
    opts = {
        git = {
            enable = true,
            ignore = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
            timeout = 5000,
        },
        view = {
            adaptive_size = false,
            width = 36,
        },
        renderer = {
            full_name = true,
            highlight_opened_files = 'all',
            root_folder_label = ':~:s?$?/..?',
            indent_width = 2,
            indent_markers = {
                enable = true,
            },
            icons = {
                -- git_placement = "signcolumn",
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = false,
                    git = true,
                }
            }
        },
        update_focused_file = {
            enable = true,
            update_root = true,
            ignore_list = { "help" },
        },
        hijack_unnamed_buffer_when_opening = true,
        sync_root_with_cwd = true,
    },
    keys = {
        vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeFocus<CR>'),
        vim.keymap.set('n', '<leader>er', '<Cmd>NvimTreeRefresh<CR>'),
    }
}

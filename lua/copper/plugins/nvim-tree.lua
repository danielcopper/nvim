return {
    'nvim-tree/nvim-tree.lua',
    lazy = false, -- opens the tree on nvim startup without a autocmd
    opts = {
        hijack_unnamed_buffer_when_opening = true,
        disable_netrw = true,
        hijack_cursor = false,
        hijack_netrw = true,
        sync_root_with_cwd = false,
        reload_on_bufenter = true,
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
            preserve_window_proportions = true,
        },
        renderer = {
            full_name = true,
            highlight_opened_files = 'all',
            -- root_folder_label = ':~:s?$?/..?',
            root_folder_label = ':t',
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
        actions = {
            change_dir = {
                restrict_above_cwd = false,
            }
        }
    },
    keys = {
        vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeFocus<CR>'),
        vim.keymap.set('n', '<leader>er', '<Cmd>NvimTreeRefresh<CR>'),
    }
}

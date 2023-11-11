local icons = require("copper.utils.icons")

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = false,
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            { "<leader>fe", "<Cmd>Neotree focus<CR>",  { desc = "Focus on Neotree" } },
            { "<leader>te", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" } },
        },
        init = function()
            if vim.fn.argc() == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            filesystem = {
                filtered_items = {
                    visible = true, -- when true, they will just be displayed differently than normal items
                },
                bind_to_cwd = true,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                width = 27,
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = icons.git.Added,
                    -- modified = icons.git.Modified,
                    modified = "IamModified",

                    deleted = icons.git.Removed, -- this can only be used in the git_status source
                    renamed = icons.git.Renamed, -- this can only be used in the git_status source
                    -- Status type
                    untracked = icons.git.Untracked,
                    ignored = icons.git.IgnoredAlt,
                    unstaged = icons.git.Unstaged,
                    staged = icons.git.Staged,
                    conflict = icons.git.Conflict,
                },
            },
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        enabled = true,
        init = function()
            require("nvim-tree")
        end,
        opts = {
            filters = {
                dotfiles = false,
            },
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = true,
            hijack_unnamed_buffer_when_opening = false,
            sync_root_with_cwd = true,
            reload_on_bufenter = true,
            git = {
                enable = true,
                ignore = false,
                show_on_dirs = true,
                show_on_open_dirs = true,
                timeout = 5000,
            },
            view = {
                adaptive_size = false,
                side = "left",
                width = 30,
                preserve_window_proportions = true,
            },
            filesystem_watchers = {
                enable = true,
            },
            renderer = {
                full_name = true,
                highlight_opened_files = "all",
                -- root_folder_label = ':~:s?$?/..?',
                root_folder_label = ":t",
                -- root_folder_label = false,
                indent_width = 2,
                indent_markers = {
                    enable = true,
                },
                icons = {
                    git_placement = "signcolumn",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                glyphs = {
                    default = "󰈚",
                    symlink = "",
                    folder = {
                        default = "",
                        empty = "",
                        empty_open = "",
                        open = "",
                        symlink = "",
                        symlink_open = "",
                        arrow_open = "",
                        arrow_closed = "",
                    },
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                },
                },

            },
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            actions = {
                open_file = {
                    resize_window = true,
                },
                change_dir = {
                    restrict_above_cwd = false,
                },
            },
        },
        keys = {
            { "<leader>fe", "<Cmd>NvimTreeFocus<CR>",   { desc = "Focus on NvimTree" } },
            { "<leader>te", "<Cmd>NvimTreeToggle<CR>",  { desc = "Toggle NvimTree" } },
            { "<leader>tr", "<Cmd>NvimTreeRefresh<CR>", { desc = "Refresh NvimTree" } },
        },
    },
}

-- Plugins that enable basic Editor features like file explorer, git plugins etc.

local set = vim.keymap.set

return {
    -- File explorer
    -- Neotree or NvimTree below
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = false,
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            { "<leader>fe", "<Cmd>Neotree focus<CR>",  { desc = "Focus on Neotree" } },
            { "<leader>te", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" } },
            -- NOTE: Needed if the other commented options are enabled
            -- {
            --     "<leader>fe",
            --     function()
            --         require("neo-tree.command").execute({
            --             position = "left",
            --             toggle = true,
            --         })
            --     end,
            --     desc = "Open Neotree in sidebar",
            -- },
        },
        init = function()
            -- NOTE: To open neotree on startup without specifying it in autocmd file
            -- autocmd would require neotree to be installed
            -- vim.api.nvim_create_autocmd("VimEnter", {
            --     command = "Neotree"
            -- })

            -- NOTE: Somehow this doesn't break the design currently
            -- TODO: check if update fixed it
            require("neo-tree")
        end,
        opts = {
            -- NOTE: This would open neotree in the current window by default
            -- helpful if you want to open neotree fullscreen on startup,
            -- comes with some drawback though like the no name buffer and closing
            -- after selecting a file to open.
            -- window = { position = "current" }
            filesystem = {
                filtered_items = {
                    visible = true -- when true, they will just be displayed differently than normal items
                },
                follow_current_file = {
                    enabled = true,          -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
                    leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                },
            },
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
        end,
    },

    {
        'nvim-tree/nvim-tree.lua',
        enabled = true,
        -- lazy = false, -- opens the tree on nvim startup without a autocmd
        init = function ()
            require("nvim-tree")
        end,
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
            set('n', '<leader>fe', '<Cmd>NvimTreeFocus<CR>'),
            set('n', '<leader>te', '<Cmd>NvimTreeToggle<CR>'),
            set('n', '<leader>re', '<Cmd>NvimTreeRefresh<CR>'),
        }
    },

    -- Fuzzy Finder
    {
        'nvim-telescope/telescope.nvim',
        cmd = "Telescope",
        opts = {
            defaults = {
                dynamic_preview_title = true, -- Shows the whole filepath above the preview
            }
        },
        keys = {
            set('n', '<leader>pf', function() require('telescope.builtin').find_files() end,
                { desc = 'Open Telescope find files' }),
            set('n', '<leader>td', function() require('telescope.builtin').diagnostics() end,
                { desc = 'Lists diagnostics for currently open buffers in Telescope' }),
            set('n', '<leader>ps', function() require('telescope.builtin').live_grep() end,
                { desc = 'Telescope Grep String Search' }),
            set('n', '<leader>km', function() require('telescope.builtin').keymaps() end,
                { desc = 'Lists normal mode keymappings in Telescope' }),
        }
    },

    -- Whichkey to find keybindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },

    -- Gitsigns make git status visible on the side
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = true
    },

    -- NOTE: Maybe move this to coding.lua
    -- Helps with code troubles
    {
        'folke/trouble.nvim',
        cmd = { 'TroubleToggle', 'Trouble' },
        opts = {
            position = 'right',
            icons = true,
            use_diagnostic_signs = true,
        },
        keys = {
            set('n', '<leader>to', '<cmd>Trouble<cr>',
                { desc = 'Open Workspace Diagnostics (Trouble)' }),
            set('n', '<leader>tf', '<cmd>TroubleToggle document_diagnostics<cr>',
                { desc = 'Toggle Document Diagnostics (Trouble)' }),
            set('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
                { desc = 'Toggle Workspace Diagnostics (Trouble)' }),
        }
    },
}
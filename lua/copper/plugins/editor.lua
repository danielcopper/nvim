-- Plugins that enable basic Editor features like file explorer, git plugins etc.
local set = vim.keymap.set
local icons = require("copper.plugins.extras.icons")

return {
    -- File explorer
    -- TODO: Change icons for file status
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            { "<leader>fe", "<Cmd>Neotree focus<CR>",  { desc = "Focus on Neotree" } },
            { "<leader>te", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" } },
        },
        init = function()
            require("neo-tree")
        end,
        opts = {
            filesystem = {
                filtered_items = {
                    visible = true, -- when true, they will just be displayed differently than normal items
                },
                bind_to_cwd = true,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
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
        enabled = false,
        -- lazy = false, -- opens the tree on nvim startup without a autocmd
        init = function()
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
                ignore = false,
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
                highlight_opened_files = "all",
                -- root_folder_label = ':~:s?$?/..?',
                root_folder_label = ":t",
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
                    },
                },
            },
            update_focused_file = {
                enable = true,
                update_root = true,
                ignore_list = { "help" },
            },
            actions = {
                change_dir = {
                    restrict_above_cwd = false,
                },
            },
        },
        keys = {
            set("n", "<leader>fe", "<Cmd>NvimTreeFocus<CR>"),
            set("n", "<leader>te", "<Cmd>NvimTreeToggle<CR>"),
            set("n", "<leader>re", "<Cmd>NvimTreeRefresh<CR>"),
        },
    },

    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- for better sorting performance
        },
        cmd = "Telescope",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,                  -- move to next result in list
                            ["<C-k>"] = actions.move_selection_previous,              -- move to previous result in list
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- send all entries to quickfist list an open it
                        },
                    },
                },
            })

            telescope.load_extension("fzf") -- don't forget to load the performance improvements
        end,
        keys = {
            set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" }),
            set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" }),
            set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find string in cwd" }),
            set("n", "<leader>td", function()
                require("telescope.builtin").diagnostics()
            end, { desc = "Lists diagnostics for currently open buffers in Telescope" }),
            set("n", "<leader>km", function()
                require("telescope.builtin").keymaps()
            end, { desc = "Lists normal mode keymappings in Telescope" }),
            set("n", "<leader>tn", function()
                require("telescope").extensions.notify.notify()
            end, { desc = "Show all Notifications in Telescope" }),
            set("n", "<leader>tt", "<Cmd>TodoTelescope<CR>", { desc = "Open Todos in Telescope" }),
        },
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
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = true,
    },

    -- NOTE: Maybe move this to coding.lua
    -- Helps with code troubles
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = {
            position = "right",
            icons = true,
            use_diagnostic_signs = true,
        },
        keys = {
            set("n", "<leader>to", "<cmd>Trouble<cr>", { desc = "Open Workspace Diagnostics (Trouble)" }),
            set(
                "n",
                "<leader>tf",
                "<cmd>TroubleToggle document_diagnostics<cr>",
                { desc = "Toggle Document Diagnostics (Trouble)" }
            ),
            set(
                "n",
                "<leader>tw",
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                { desc = "Toggle Workspace Diagnostics (Trouble)" }
            ),
        },
    },

    -- better text folding
    -- {
    --     "kevinhwang91/nvim-ufo",
    --     event = "BufRead",
    --     dependencies = { "kevinhwang91/promise-async" },
    --     config = function()
    --         -- Fold options
    --         -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    --         vim.o.foldcolumn = "0" -- '0' is not bad -> controls the width of the extra column for fold icons
    --         vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    --         vim.o.foldlevelstart = 99
    --         vim.o.foldenable = true
    --
    --         require("ufo").setup()
    --     end,
    -- },

    {
        "kevinhwang91/nvim-ufo",
        -- TODO: Sometimes automatically folds in neo-tree, Fix or keep disabled
        enabled = false,
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufRead",
        keys = {
            {
                "zP",
                function()
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
            },
        },
        config = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            -- To show number of folded lines
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ("  ↙ %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            require("ufo").setup({
                fold_virt_text_handler = handler,
            })

            -- Disable UFO on certain filetypes
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "neo-tree" },
                callback = function()
                    require("ufo").detach()
                    vim.opt_local.foldenable = false
                end,
            })
        end,
    },
}

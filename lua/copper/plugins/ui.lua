local set = vim.keymap.set

return {
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },

    -- better vim.ui
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },

    -- Bufferline
    {
        enabled = true,
        event = "VeryLazy",
        --lazy = false,
        'akinsho/nvim-bufferline.lua',
        opts = {
            options = {
                mode = 'buffers', -- set to "tabs" to only show tabpages instead
                offsets = {
                    {
                        filetype = 'neo-tree',
                        text = 'File Explorer',
                        --highlight = "Directory",
                        separator = false
                        --text_align = "left"
                    }
                },
                -- indicator = {
                --     style = 'underline'
                -- },
                separator_style = 'thin', -- "slant" | "thick" | "thin" | { 'any', 'any' },
                show_tab_indicators = true,
                diagnostics = 'nvim_lsp',
                --- count is an integer representing total count of errors
                --- level is a string "error" | "warning"
                --- diagnostics_dict ij a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
                --- this should return a string
                --- Don't get too fancy as this function will be executed a lot
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                color_icons = true,
                show_buffer_icons = true
            }
        },
        dependencies = {
            'ojroques/nvim-bufdel',
        },
        config = function(_, opts)
            require('bufferline').setup(opts)
            require('bufdel').setup({
                quit = false -- quit Neovim when last buffer is closed
            })
        end,
        keys = {
            set('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Select previous Buffer' }),
            set('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Select next Buffer' }),
            set('n', '<A-<>', '<Cmd>BufferLineMovePrevious<CR>', { desc = 'Move buffer to the left' }),
            set('n', '<A->>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Move Buffer to the right' }),
            set('n', '<A-1>', '<Cmd>BufferLineGoTo 1<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-2>', '<Cmd>BufferLineGoTo 2<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-3>', '<Cmd>BufferLineGoTo 3<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-4>', '<Cmd>BufferLineGoTo 4<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-5>', '<Cmd>BufferLineGoTo 5<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-6>', '<Cmd>BufferLineGoTo 6<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-7>', '<Cmd>BufferLineGoTo 7<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-8>', '<Cmd>BufferLineGoTo 8<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-9>', '<Cmd>BufferLineGoTo 9<CR>', { desc = 'Goto Buffer number 9' }),
            set('n', '<A-p>', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Pin current Buffer' }),
            set('n', '<C-p>', '<Cmd>BufferLineGoToBuffer<CR>', { desc = 'Pick Buffer to jump to' }),
            -- set('n', '<A-c>', '<Cmd>:b#|bd#<CR>', { desc = 'Close current Buffer' }),
            set('n', '<A-c>', '<Cmd>BufDel<CR>', { desc = 'Close current Buffer' }),
            -- set('n', '<leader>ca', '<Cmd>BufDelAll<CR>', { desc = 'Close all Buffer' }),
            set('n', '<leader>ca', '<Cmd>Neotree show<CR><Cmd>BufDelOthers<CR>', { desc = 'Close all Buffers' }),
            set('n', '<leader>co', '<Cmd>BufDelOthers<CR>', { desc = 'Close all but current Buffer' }),
            -- set('n', '<leader>co', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Close unpinned Buffers' }),
            -- set('n', '<leader>ca',
            --     function()
            --         for _, e in ipairs(bufferline.get_elements().elements) do
            --             vim.schedule(function()
            --                 vim.cmd("bd " ..
            --                     e.id)
            --             end)
            --         end
            --     end, { desc = 'Close all Buffers' }),
        },
    },

    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- char = "▏",
            char = "│",
            filetype_exclude = {
                "help",
                "neo-tree",
                "Trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
            show_trailing_blankline_indent = false,
            show_current_context = false,
        },
    },

    -- animates the indentscope
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- symbol = "▏",
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "neo-tree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- noicer ui
    {
        "folke/which-key.nvim",
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
        -- stylua: ignore
        keys = {
            {
                "<S-Enter>",
                function() require("noice").redirect(vim.fn.getcmdline()) end,
                mode = "c",
                desc =
                "Redirect Cmdline"
            },
            {
                "<leader>snl",
                function() require("noice").cmd("last") end,
                desc =
                "Noice Last Message"
            },
            {
                "<leader>snh",
                function() require("noice").cmd("history") end,
                desc =
                "Noice History"
            },
            {
                "<leader>sna",
                function() require("noice").cmd("all") end,
                desc =
                "Noice All"
            },
            {
                "<leader>snd",
                function() require("noice").cmd("dismiss") end,
                desc =
                "Dismiss All"
            },
            {
                "<c-f>",
                function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
                silent = true,
                expr = true,
                desc =
                "Scroll forward",
                mode = {
                    "i", "n", "s" }
            },
            {
                "<c-b>",
                function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
                silent = true,
                expr = true,
                desc =
                "Scroll backward",
                mode = {
                    "i", "n", "s" }
            },
        },
    },

    -- devicons used by many plugins
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ui components
    { "MunifTanjim/nui.nvim",        lazy = true },
}

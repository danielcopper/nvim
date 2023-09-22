-- UI related plugins for Neovim

local set = vim.keymap.set

return {
    -- Notifications
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
            background_colour = "#000000",
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },

    -- Improves the UI for input and select options
    -- for example for code actions
    -- NOTE: Try to simplify this setup
    {
        "stevearc/dressing.nvim",
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

    -- Bufferline (the tabs on top)
    {
        enabled = true,
        event = "VeryLazy",
        --lazy = false,
        "akinsho/nvim-bufferline.lua",
        opts = {
            options = {
                mode = "buffers", -- set to "tabs" to only show tabpages instead
                offsets = {
                    {
                        -- NOTE: Pick one
                        filetype = "neo-tree",
                        -- filetype = "NvimTree",
                        text = "File Explorer",
                        --highlight = "Directory",
                        separator = true,
                        --text_align = "left"
                    },
                },
                -- indicator = {
                --     style = 'underline'
                -- },
                separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
                show_tab_indicators = true,
                diagnostics = "nvim_lsp",
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
                show_buffer_icons = true,
            },
        },
        config = function(_, opts)
            require("bufferline").setup(opts)
            require("bufdel").setup({
                quit = false, -- quit Neovim when last buffer is closed
            })
        end,
        keys = {
            set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Move to Prev buffer" }),
            set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Move to Next buffer" }),
            set("n", "<A-,>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Move to Prev buffer", remap = true }),
            set("n", "<A-.>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Move to Next buffer", remap = true }),
            set("n", "<A-<>", "<Cmd>BufferLineMovePrevious<CR>", { desc = "Move buffer to the left" }),
            set("n", "<A->>", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move Buffer to the right" }),
            set("n", "<A-1>", "<Cmd>BufferLineGoTo 1<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-2>", "<Cmd>BufferLineGoTo 2<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-3>", "<Cmd>BufferLineGoTo 3<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-4>", "<Cmd>BufferLineGoTo 4<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-5>", "<Cmd>BufferLineGoTo 5<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-6>", "<Cmd>BufferLineGoTo 6<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-7>", "<Cmd>BufferLineGoTo 7<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-8>", "<Cmd>BufferLineGoTo 8<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-9>", "<Cmd>BufferLineGoTo 9<CR>", { desc = "Goto Buffer number 9" }),
            set("n", "<A-p>", "<Cmd>BufferLineTogglePin<CR>", { desc = "Pin current Buffer" }),
            set("n", "<C-p>", "<Cmd>BufferLineGoToBuffer<CR>", { desc = "Pick Buffer to jump to" }),
            -- set('n', '<A-c>', '<Cmd>:b#|bd#<CR>', { desc = 'Close current Buffer' }),
            set("n", "<A-c>", "<Cmd>BufDel<CR>", { desc = "Close current Buffer" }),
            set(
                "n",
                "<leader>bca",
                "<C-w>h <bar> <Cmd>BufDelOthers<CR>",
                { desc = "Close all Buffers but File Explorer" }
            ),
            set("n", "<leader>bcA", "<Cmd>BufDelAll<CR>", { desc = "Close all Buffers" }),
            set("n", "<leader>bco", "<Cmd>BufDelOthers<CR>", { desc = "Close all but current Buffer" }),
            set("n", "<leader>bcu", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Close unpinned Buffers" }),
        },
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local lazy_status = require("lazy.status")
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "lazy", "alpha" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                Error = " ",
                                Warn = " ",
                                Hint = " ",
                                Info = " ",
                            },
                        },
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = {
                                left = 1,
                                right = 0,
                            },
                        },
                        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                        {
                            -- Breadcrumbs in the statusline
                            function()
                                return require("nvim-navic").get_location()
                            end,
                            cond = function()
                                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                            end,
                        },
                    },
                    -- TODO: Set colors and check what x to z actually display
                    lualine_x = {
                        -- {
                        --     function()
                        --         return require("noice").api.status.command.get()
                        --     end,
                        --     cond = function()
                        --         return package.loaded["noice"] and require("noice").api.status.command.has()
                        --     end,
                        --     -- color = Util.fg("Statement"),
                        -- },
                        -- {
                        --     function()
                        --         return require("noice").api.status.mode.get()
                        --     end,
                        --     cond = function()
                        --         return package.loaded["noice"] and require("noice").api.status.mode.has()
                        --     end,
                        --     -- color = Util.fg("Constant"),
                        -- },
                        {
                            function()
                                return "  " .. require("dap").status()
                            end,
                            cond = function()
                                return package.loaded["dap"] and require("dap").status() ~= ""
                            end,
                            -- color = Util.fg("Debug"),
                        },
                        {
                            lazy_status.updates,
                            cond = lazy_status.has_updates,
                            color = { fg = "#ff9e64" },
                        },
                        {
                            "diff",
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " ",
                            },
                        },
                        -- OLD stuff
                        { "encoding" },
                        { "fileformat" },
                        { "filetype" },
                    },
                    lualine_y = {
                        { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
                -- show a simplified lualine for these
                extensions = { "neo-tree", "nvim-tree", "lazy" },
            })
        end,
    },

    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
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
    -- TODO: Only seems to work in lua workspaces.
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
                desc = "Redirect Cmdline"
            },
            {
                "<leader>snl",
                function() require("noice").cmd("last") end,
                desc = "Noice Last Message"
            },
            {
                "<leader>snh",
                function() require("noice").cmd("history") end,
                desc = "Noice History"
            },
            {
                "<leader>sna",
                function() require("noice").cmd("all") end,
                desc = "Noice All"
            },
            {
                "<leader>snd",
                function() require("noice").cmd("dismiss") end,
                desc = "Dismiss All"
            },
            {
                "<c-f>",
                function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
                silent = true,
                expr = true,
                desc = "Scroll forward",
                mode = { "i", "n", "s" }
            },
            {
                "<c-b>",
                function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
                silent = true,
                expr = true,
                desc = "Scroll backward",
                mode = { "i", "n", "s" }
            },
        },
    },

    -- animate scrolling and cursor movements
    -- TODO: C-f and C-b are overwritten by this! Disable that -> it interferes with cmp => !!!
    {
        "declancm/cinnamon.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("cinnamon").setup({
                -- KEYMAPS:
                default_keymaps = true, -- Create default keymaps.
                extra_keymaps = true, -- Create extra keymaps.
                extended_keymaps = false, -- Create extended keymaps.
                override_keymaps = true, -- The plugin keymaps will override any existing keymaps.

                -- OPTIONS:
                always_scroll = false, -- Scroll the cursor even when the window hasn't scrolled.
                centered = true, -- Keep cursor centered in window when using window scrolling.
                disabled = false, -- Disables the plugin.
                default_delay = 4, -- The default delay (in ms) between each line when scrolling.
                hide_cursor = false, -- Hide the cursor while scrolling. Requires enabling termguicolors!
                horizontal_scroll = true, -- Enable smooth horizontal scrolling when view shifts left or right.
                max_length = -1, -- Maximum length (in ms) of a command. The line delay will be
                -- re-calculated. Setting to -1 will disable this option.
                scroll_limit = 150, -- Max number of lines moved before scrolling is skipped. Setting
                -- to -1 will disable this option.
            })
        end,
    },

    -- lsp symbol navigation for lualine. This shows where
    -- in the code structure you are - within functions, classes,
    -- etc - in the statusline.
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local buffer = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("nvim-navic").attach(client, buffer)
                end,
            })
        end,
        opts = function()
            return {
                separator = " ",
                highlight = true,
                depth_limit = 5,
                icons = {
                    Array = " ",
                    Boolean = " ",
                    Class = " ",
                    Color = " ",
                    Constant = " ",
                    Constructor = " ",
                    Copilot = " ",
                    Enum = " ",
                    EnumMember = " ",
                    Event = " ",
                    Field = " ",
                    File = " ",
                    Folder = " ",
                    Function = " ",
                    Interface = " ",
                    Key = " ",
                    Keyword = " ",
                    Method = " ",
                    Module = " ",
                    Namespace = " ",
                    Null = " ",
                    Number = " ",
                    Object = " ",
                    Operator = " ",
                    Package = " ",
                    Property = " ",
                    Reference = " ",
                    Snippet = " ",
                    String = " ",
                    Struct = " ",
                    Text = " ",
                    TypeParameter = " ",
                    Unit = " ",
                    Value = " ",
                    Variable = " ",
                },
            }
        end,
    },

    -- Provides color previews in css
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufEnter" },
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = true, -- "Name" codes like Blue or blue
                RRGGBBAA = false, -- #RRGGBBAA hex codes
                AARRGGBB = false, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = false, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "virtualtext", -- Set the display mode.
                -- Available methods are false / true / "normal" / "lsp" / "both"
                -- True is same as normal
                tailwind = false,                  -- Enable tailwind colors
                -- parsers can contain values used in |user_default_options|
                sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
                virtualtext = "■",
                -- update color values even if buffer is not focused
                -- example use: cmp_menu, cmp_docs
                always_update = false,
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
        },
    },

    -- More detailed lsp diagnostics info
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = { "BufEnter" },
        config = function()
            vim.diagnostic.config({
                virtual_text = false,
            })

            -- Disable the plugin in specified filetypes
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "lazy",
                callback = function()
                    local previous = not require("lsp_lines").toggle()
                    if not previous then
                        require("lsp_lines").toggle()
                    end
                end,
            })

            require("lsp_lines").setup()
        end,
    },

    -- devicons used by many plugins
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ui components
    { "MunifTanjim/nui.nvim",        lazy = true },
}

return {
    {
        'rose-pine/neovim',
        enabled = false,
        name = 'rose-pine',
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                --- @usage 'main' | 'moon'
                dark_variant = 'main',
                bold_vert_split = false,
                -- set non active background to a lighter color
                dim_nc_background = false,
                disable_background = true,
                disable_float_background = true,
                disable_italics = false,
                --- @usage string hex value or named color from rosepinetheme.com/palette
                groups = {
                    background = 'base',
                    panel = 'surface',
                    border = 'highlight_med',
                    comment = 'muted',
                    link = 'iris',
                    punctuation = 'subtle',

                    error = 'love',
                    hint = 'iris',
                    info = 'foam',
                    warn = 'gold',

                    headings = {
                        h1 = 'iris',
                        h2 = 'foam',
                        h3 = 'rose',
                        h4 = 'gold',
                        h5 = 'pine',
                        h6 = 'foam',
                    }
                    -- or set all headings at once
                    -- headings = 'subtle'
                },
                -- Change specific vim highlight groups
                -- highlight_groups = {
                --     ColorColumn = { bg = 'highlight_low' }
                -- }
            })
            vim.cmd('colorscheme rose-pine')
        end
    },

    {
        'catppuccin/nvim',
        enabled = false,
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
                show_end_of_buffer = false,
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
            })
            -- setup must be called before loading
            vim.cmd.colorscheme 'catppuccin'
        end
    },

    {
        'folke/tokyonight.nvim',
        enabled = false,
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                light_style = "day", -- The theme is used when the background is set to light
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "transparent", -- style for sidebars, see below
                    floats = "transparent", -- style for floating windows
                },
                sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
                day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
                hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
                dim_inactive = false, -- dims inactive windows
                lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
                --- You can override specific color groups to use other groups or a hex color
                --- function will be called with a ColorScheme table
                ---@param colors ColorScheme
                on_colors = function(colors)
                end,
                --- You can override specific highlights to use other groups or a hex color
                --- function will be called with a Highlights and ColorScheme table
                ---@param highlights Highlights
                ---@param colors ColorScheme
                on_highlights = function(highlights, colors)
                end,
            })

            vim.cmd.colorscheme 'tokyonight'
        end
    },

    {
        'rebelot/kanagawa.nvim',
        enabled = true,
        config = function()
            -- Default options:
            require('kanagawa').setup({
                undercurl = true, -- enable undercurls
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                variablebuiltinStyle = { italic = true },
                specialReturn = true, -- special highlight for the return keyword
                specialException = true, -- special highlight for exception handling keywords
                transparent = true, -- do not set background color
                dimInactive = false, -- dim inactive window `:h hl-NormalNC`
                globalStatus = false, -- adjust window separators highlight for laststatus=3
                terminalColors = true, -- define vim.g.terminal_color_{0,17}
                colors = {},
                overrides = {},
                theme = "default" -- Load "default" theme or the experimental "light" theme
            })

            -- setup must be called before loading
            vim.cmd.colorscheme 'kanagawa'
        end
    },

    {
        -- TODO: Make the original work
        -- 'sainnhe/everforest',
        'neanias/everforest-nvim',
        enabled = false,
        config = function()
            require('everforest').setup({
                -- Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
                -- Default is "medium".
                background = "medium",
                -- How much of the background should be transparent. Options are 0, 1 or 2.
                -- Default is 0.
                --
                -- 2 will have more UI components be transparent (e.g. status line
                -- background).
                transparent_background_level = 1,
                -- Whether italics should be used for keywords, builtin types and more.
                italics = false,
                -- Disable italic fonts for comments. Comments are in italics by default, set
                -- this to `true` to make them _not_ italic!
                disable_italic_comments = false,
            })

            vim.cmd.colorscheme 'everforest'
        end
    }
}

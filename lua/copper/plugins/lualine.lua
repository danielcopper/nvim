return {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    config = function()
        require 'lualine'.setup {
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
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                }
            }
        }
    end
}

return {
    enabled = false,
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            -- always_show_bufferline = false,
            diagnostics_indicator = function(_, _, diag)
                local icons = {
                    Error = " ",
                    Warn = " ",
                    Hint = " ",
                    Info = " ",
                }
                local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                    .. (diag.warning and icons.Warn .. diag.warning or "")
                return vim.trim(ret)
            end,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "NvimTree",
                    highlight = "Directory",
                    text_align = "left",
                },
            },
        },
    }
}

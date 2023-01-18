return {
    'nvim-lualine/lualine.nvim',
    init = function()
        require('lualine').setup ({
            -- TODO - fix this, it is not working
            -- disabled_filetypes = { "NvimTree" },
            -- globalstatus = true
        })
    end
}

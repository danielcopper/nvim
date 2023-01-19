return {
    'nvim-lualine/lualine.nvim',
    init = function()
        require 'lualine'.setup {
            options = {
                disabled_filetypes = { 'alpha' },
                globalstatus = true
            }
        }
    end
}

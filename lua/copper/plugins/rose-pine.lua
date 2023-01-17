return {
    'rose-pine/neovim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    name = 'rose-pine',
    init = function()

        -- fine tune color settings from rosepine theme thats loaded from lazy.lua
        -- this sets rose pine as a default fall back
        function ColorMyPencils(color)
            color = color or "rose-pine"
            vim.cmd.colorscheme(color)

            -- transparent background
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end

        ColorMyPencils()
    end,
    config = function()
        vim.cmd('colorscheme rose-pine')
    end
}

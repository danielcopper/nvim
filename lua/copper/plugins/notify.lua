return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            level = "INFO",
            stages = "fade_in_slide_out",
            background_colour = "#000000",
        })
    end,
    keys = {
        {
            "<leader>un",
            function()
                require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Delete all Notifications",
        },
    },
    opts = {
        timeout = 3500,
        max_height = function()
            return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
            return math.floor(vim.o.columns * 0.75)
        end,
    }
}

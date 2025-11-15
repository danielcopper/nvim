return {
    "rachartier/tiny-glimmer.nvim",
    enabled = false, -- DISABLED: Blocks paste operations
    event = "VeryLazy",
    priority = 10, -- Low priority to catch other plugins' keybindings
    config = function()
        require("tiny-glimmer").setup()
    end
}

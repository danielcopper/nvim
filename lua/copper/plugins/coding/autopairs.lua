return {
    -- autoinsert matching pairs
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("ultimate-autopair").setup({})
        end,
    },
}

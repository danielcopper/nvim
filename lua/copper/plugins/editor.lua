local set = vim.keymap.set

return {
    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        config = function()
            require("neo-tree").setup()
        end,
    },
    --	{
    --		"nvim-tree/nvim-tree.lua",
    --  version = "*",
    --  lazy = false,
    --  dependencies = {
    --   "nvim-tree/nvim-web-devicons",
    -- },
    -- config = function()
    --   require("nvim-tree").setup {}
    -- end,
    --	},

}

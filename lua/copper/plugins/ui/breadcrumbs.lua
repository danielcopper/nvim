local icons = require("copper.plugins.extras.icons")

return {
    -- lsp symbol navigation for lualine. This shows where
    -- in the code structure you are - within functions, classes,
    -- etc - in the statusline.
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local buffer = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("nvim-navic").attach(client, buffer)
                end,
            })
        end,
        opts = function()
            return {
                separator = " ",
                highlight = true,
                depth_limit = 5,
                icons = icons.kinds,
            }
        end,
    },
}

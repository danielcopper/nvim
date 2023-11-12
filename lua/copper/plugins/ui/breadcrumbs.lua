local icons = require("copper.utils.icons")

return {
  -- lsp symbol navigation for lualine. This shows where
  -- in the code structure you are - within functions, classes,
  -- etc - in the statusline.
  {
    "SmiteshP/nvim-navic",
    -- init = function()
    --     vim.g.navic_silence = true
    --     vim.api.nvim_create_autocmd("LspAttach", {
    --         callback = function(args)
    --             local buffer = args.buf
    --             local client = vim.lsp.get_client_by_id(args.data.client_id)
    --             require("nvim-navic").attach(client, buffer)
    --         end,
    --     })
    -- end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 7,
        icons = icons.kinds,
      }
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    event = "BufReadPre",
    opts = {
      show_basename = false,
      show_dirname = false,
      theme = "catppuccin-mocha"
    },
  }
}

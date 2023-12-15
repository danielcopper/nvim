local icons = require("copper.config.icons")

return {
  {
    "utilyre/barbecue.nvim",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      show_basename = true,
      show_dirname = false,
      theme = "auto",
      kinds = icons.kinds,
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
    },
  }
}

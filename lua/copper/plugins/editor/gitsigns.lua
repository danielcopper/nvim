local icons = require("copper.config.icons")

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = icons.gitsigns.add },
      change = { text = icons.gitsigns.change },
      delete = { text = icons.gitsigns.delete },
      topdelete = { text = icons.gitsigns.topdelete },
      changedelete = { text = icons.gitsigns.changedelete },
      untracked = { text = icons.gitsigns.untracked },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
      delay = 1500,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    preview_config = {
      border = vim.copper_config.borders
    },
  },
}

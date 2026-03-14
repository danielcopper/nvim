-- Bufferline: Buffer tabs at the top

local icons = require("config.icons")

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
    { "<leader>bP", "<cmd>BufferLinePickClose<cr>", desc = "Pick buffer to close" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
    { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
    { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
  },
  opts = {
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local s = {}
        if diag.error then table.insert(s, icons.diagnostics.error .. diag.error) end
        if diag.warning then table.insert(s, icons.diagnostics.warn .. diag.warning) end
        return table.concat(s, " ")
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "Directory",
          separator = true,
        },
      },
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = "thin",
      always_show_bufferline = false,
      show_tab_indicators = true,
    },
  },
}

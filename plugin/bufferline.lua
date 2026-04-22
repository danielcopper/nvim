vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/akinsho/bufferline.nvim",
})

local icons = require("icons")

require("bufferline").setup({
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
})

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })
vim.keymap.set("n", "<leader>bP", "<cmd>BufferLinePickClose<cr>", { desc = "Pick buffer to close" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to the right" })
vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to the left" })

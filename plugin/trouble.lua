vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/folke/trouble.nvim",
})

local icons = require("icons")

require("trouble").setup({
  modes = {
    diagnostics = {
      auto_open = false,
      auto_close = false,
    },
  },
  icons = {
    indent = {
      middle = "├╴",
      last = "└╴",
      top = "│ ",
      ws = "  ",
    },
    folder_closed = icons.ui.folder,
    folder_open = icons.ui.folder_open,
    kinds = icons.lsp.kinds,
  },
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

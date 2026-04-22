vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/pwntester/octo.nvim",
})

if vim.fn.executable("gh") == 0 then return end

require("octo").setup({
  enable_builtin = true,
  default_merge_method = "squash",
  picker = "telescope",
})

vim.keymap.set("n", "<leader>gi", "<cmd>Octo issue list<cr>", { desc = "List issues" })
vim.keymap.set("n", "<leader>gI", "<cmd>Octo issue search<cr>", { desc = "Search issues" })
vim.keymap.set("n", "<leader>gp", "<cmd>Octo pr list<cr>", { desc = "List PRs" })
vim.keymap.set("n", "<leader>gP", "<cmd>Octo pr search<cr>", { desc = "Search PRs" })

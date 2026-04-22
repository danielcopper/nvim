vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/saxon1964/neovim-tips",
})

require("neovim_tips").setup({
  daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
  bookmark_symbol = "🌟 ",
  "https://github.com/MunifTanjim/nui.nvim",
})

vim.keymap.set("n", "<leader>tto", ":NeovimTips<CR>", { desc = "Neovim tips", silent = true })
vim.keymap.set("n", "<leader>tte", ":NeovimTipsEdit<CR>", { desc = "Edit your Neovim tips", silent = true })
vim.keymap.set("n", "<leader>tta", ":NeovimTipsAdd<CR>", { desc = "Add your Neovim tip", silent = true })
vim.keymap.set("n", "<leader>tth", ":help neovim-tips<CR>", { desc = "Neovim tips help", silent = true })
vim.keymap.set("n", "<leader>ttr", ":NeovimTipsRandom<CR>", { desc = "Show random tip", silent = true })
vim.keymap.set("n", "<leader>ttp", ":NeovimTipsPdf<CR>", { desc = "Open Neovim tips PDF", silent = true })

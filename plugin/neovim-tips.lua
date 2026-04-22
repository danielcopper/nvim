vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/saxon1964/neovim-tips",
})

local tips_state = vim.fn.stdpath("state") .. "/neovim_tips"
local is_fresh_install = vim.fn.isdirectory(tips_state) == 0

require("neovim_tips").setup({
  daily_tip = is_fresh_install and 0 or 1,
  bookmark_symbol = "🌟 ",
})

vim.keymap.set("n", "<leader>tto", ":NeovimTips<CR>", { desc = "Neovim tips", silent = true })
vim.keymap.set("n", "<leader>tte", ":NeovimTipsEdit<CR>", { desc = "Edit your Neovim tips", silent = true })
vim.keymap.set("n", "<leader>tta", ":NeovimTipsAdd<CR>", { desc = "Add your Neovim tip", silent = true })
vim.keymap.set("n", "<leader>tth", ":help neovim-tips<CR>", { desc = "Neovim tips help", silent = true })
vim.keymap.set("n", "<leader>ttr", ":NeovimTipsRandom<CR>", { desc = "Show random tip", silent = true })
vim.keymap.set("n", "<leader>ttp", ":NeovimTipsPdf<CR>", { desc = "Open Neovim tips PDF", silent = true })

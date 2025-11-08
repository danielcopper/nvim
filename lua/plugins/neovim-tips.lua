return {
  "saxon1964/neovim-tips",
  version = "*",
  lazy = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "OXY2DEV/markview.nvim",
  },
  opts = {
    daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
    bookmark_symbol = "🌟 ",
  },
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips", silent = true })
    map("n", "<leader>nte", ":NeovimTipsEdit<CR>", { desc = "Edit your Neovim tips", silent = true })
    map("n", "<leader>nta", ":NeovimTipsAdd<CR>", { desc = "Add your Neovim tip", silent = true })
    map("n", "<leader>nth", ":help neovim-tips<CR>", { desc = "Neovim tips help", silent = true })
    map("n", "<leader>ntr", ":NeovimTipsRandom<CR>", { desc = "Show random tip", silent = true })
    map("n", "<leader>ntp", ":NeovimTipsPdf<CR>", { desc = "Open Neovim tips PDF", silent = true })
  end
}

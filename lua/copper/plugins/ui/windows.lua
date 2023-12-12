return {
  "anuvyklack/windows.nvim",
  enabled = false,
  event = "WinNew",
  dependencies = {
    { "anuvyklack/middleclass" },
    { "anuvyklack/animation.nvim", enabled = true },
  },
  opts = {
    animation = { enable = true, duration = 150, fps = 60 },
    autowidth = { enable = true },
  },
  keys = { { "<leader>m", "<cmd>WindowsMaximize<CR>", desc = "Zoom window" } },
  init = function()
    vim.o.winwidth = 30
    vim.o.winminwidth = 30
    vim.o.equalalways = true
  end,
}

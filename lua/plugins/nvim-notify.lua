return {
  "rcarriga/nvim-notify",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss All Notifications" },
    { "<leader>n", "<cmd>Telescope notify<cr>", desc = "Notification History" },
  },
  config = function()
    require("notify").setup()
    vim.notify = require("notify")
  end,
}

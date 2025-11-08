return {
  "rcarriga/nvim-notify",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss All Notifications" },
    { "<leader>n", "<cmd>Telescope notify<cr>", desc = "Notification History" },
  },
  opts = {
    stages = "fade_in_slide_out",
  },
  config = function(_, opts)
    require("notify").setup(opts)
    vim.notify = require("notify")
  end,
}

return {
  "rcarriga/nvim-notify",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss All Notifications" },
    { "<leader>n", "<cmd>Telescope notify<cr>", desc = "Notification History" },
  },
  config = function()
    local harmony = require("harmony")

    local opts = {
      stages = "fade_in_slide_out",
      render = "compact",
      border = harmony.border(),
    }

    -- Set background color for borderless mode
    if harmony.border() == "none" then
      local colors = harmony.get_colors()
      opts.background_colour = colors.bg_dark
    end

    require("notify").setup(opts)
    vim.notify = require("notify")
  end,
}

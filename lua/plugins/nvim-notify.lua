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
    local theme_config = require("copper.theme.config")

    -- Set border based on theme system
    opts.render = "compact"
    opts.border = theme_config.borders

    -- Set background color for borderless mode
    if theme_config.borders == "none" then
      local colors = require("copper.theme").get_colors()
      opts.background_colour = colors.bg_dark
    end

    require("notify").setup(opts)
    vim.notify = require("notify")
  end,
}

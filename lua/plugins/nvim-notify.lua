local helpers = require("config.theme.helpers")
local icons = require("config.theme.icons")

return {
  "rcarriga/nvim-notify",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss All Notifications" },
    { "<leader>n", "<cmd>Telescope notify<cr>", desc = "Notification History" },
  },
  opts = function()
    local palette = helpers.get_palette()
    local border = helpers.get_border()

    return {
      stages = "fade",
      timeout = 3000,
      render = "default",
      background_colour = palette and palette.base or "#1e1e2e",
      max_width = 50,
      max_height = 10,
      icons = {
        ERROR = icons.diagnostics.error,
        WARN = icons.diagnostics.warn,
        INFO = icons.diagnostics.info,
        DEBUG = icons.diagnostics.hint,
        TRACE = "✎",
      },
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { border = border })
      end,
    }
  end,
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}

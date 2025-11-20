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

    -- Use darkest catppuccin background for notifications
    local notify_bg = palette and palette.crust or "#11111b"

    -- Custom stages with spacing between notifications
    local custom_stages = (function()
      local stages_util = require("notify.stages.util")
      local direction = stages_util.DIRECTION.TOP_DOWN
      local spacing = 1 -- Lines of spacing between notifications

      return {
        function(state)
          local next_height = state.message.height + 2
          local next_row = stages_util.available_slot(state.open_windows, next_height + spacing, direction)
          if not next_row then
            return nil
          end
          return {
            relative = "editor",
            anchor = "NE",
            width = state.message.width,
            height = state.message.height,
            col = vim.opt.columns:get(),
            row = next_row,
            border = border,
            style = "minimal",
            opacity = 0,
          }
        end,
        function(state, win)
          return {
            opacity = { 100 },
            col = { vim.opt.columns:get() },
            row = {
              stages_util.slot_after_previous(win, state.open_windows, direction) + spacing,
              frequency = 3,
              complete = function()
                return true
              end,
            },
          }
        end,
        function(state, win)
          return {
            col = { vim.opt.columns:get() },
            time = true,
            row = {
              stages_util.slot_after_previous(win, state.open_windows, direction) + spacing,
              frequency = 3,
              complete = function()
                return true
              end,
            },
          }
        end,
        function(state, win)
          return {
            width = {
              1,
              frequency = 2.5,
              damping = 0.9,
              complete = function(cur_width)
                return cur_width < 3
              end,
            },
            opacity = {
              0,
              frequency = 2,
              complete = function(cur_opacity)
                return cur_opacity <= 4
              end,
            },
            col = { vim.opt.columns:get() },
            row = {
              stages_util.slot_after_previous(win, state.open_windows, direction) + spacing,
              frequency = 3,
              complete = function()
                return true
              end,
            },
          }
        end,
      }
    end)()

    return {
      stages = custom_stages,
      timeout = 3000,
      render = "wrapped-compact",
      background_colour = notify_bg,
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

    -- Patch nvim-notify to fix NormalNC:NONE gap issue (GitHub issue #335)
    -- Override setwinvar to replace NormalNC:NONE with NormalNC:<body_hl>
    local original_setwinvar = vim.fn.setwinvar
    vim.fn.setwinvar = function(winnr, varname, value)
      if varname == "&winhl" and type(value) == "string" and value:match("NormalNC:NONE") then
        -- Replace NormalNC:NONE with NormalNC matching the body highlight
        value = value:gsub("NormalNC:NONE", function()
          local body_hl = value:match("Normal:(%w+Body)")
          return body_hl and ("NormalNC:" .. body_hl) or "NormalNC:Normal"
        end)
      end
      return original_setwinvar(winnr, varname, value)
    end
  end,
}

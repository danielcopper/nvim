vim.pack.add({ "https://github.com/rcarriga/nvim-notify" })

local icons = require("icons")
local border = require("ui").borders

local stages_util = require("notify.stages.util")
local direction = stages_util.DIRECTION.TOP_DOWN
local spacing = 1

local opts = {
  timeout = 3000,
  render = "wrapped-compact",
  max_width = 50,
  max_height = 10,
  background_colour = "#11111b", -- catppuccin mocha crust
  icons = {
    ERROR = icons.diagnostics.error,
    WARN = icons.diagnostics.warn,
    INFO = icons.diagnostics.info,
    DEBUG = icons.diagnostics.hint,
    TRACE = "✎",
  },
  stages = {
    function(state)
      local next_height = state.message.height + 2
      local next_row = stages_util.available_slot(state.open_windows, next_height + spacing, direction)
      if not next_row then return nil end
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
          complete = function() return true end,
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
          complete = function() return true end,
        },
      }
    end,
    function(state, win)
      return {
        width = {
          1,
          frequency = 2.5,
          damping = 0.9,
          complete = function(cur_width) return cur_width < 3 end,
        },
        opacity = {
          0,
          frequency = 2,
          complete = function(cur_opacity) return cur_opacity <= 4 end,
        },
        col = { vim.opt.columns:get() },
        row = {
          stages_util.slot_after_previous(win, state.open_windows, direction) + spacing,
          frequency = 3,
          complete = function() return true end,
        },
      }
    end,
  },
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { border = border })
  end,
}

local notify = require("notify")
notify.setup(opts)
vim.notify = notify

-- Patch nvim-notify to fix NormalNC:NONE gap issue (GitHub issue #335)
local original_setwinvar = vim.fn.setwinvar
vim.fn.setwinvar = function(winnr, varname, value)
  if varname == "&winhl" and type(value) == "string" and value:match("NormalNC:NONE") then
    value = value:gsub("NormalNC:NONE", function()
      local body_hl = value:match("Normal:(%w+Body)")
      return body_hl and ("NormalNC:" .. body_hl) or "NormalNC:Normal"
    end)
  end
  return original_setwinvar(winnr, varname, value)
end

vim.keymap.set("n", "<leader>un", function() notify.dismiss({ silent = true, pending = true }) end, { desc = "Dismiss All Notifications" })
vim.keymap.set("n", "<leader>tn", "<cmd>Telescope notify<cr>", { desc = "Notifications" })

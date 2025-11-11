-- Central theme configuration
-- Single source of truth for all theme-related settings

local M = {
  -- Current theme settings
  colorscheme = "catppuccin",
  borders = "none", -- none | single | rounded | double
  transparency = false,
  padding = { 0, 1 }, -- Default padding for floating windows: {vertical, horizontal}

  -- Border character definitions for telescope and other plugins
  border_chars = {
    none = { " ", " ", " ", " ", " ", " ", " ", " " },
    single = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    double = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
  },

  -- Control which integrations are active
  integrations = {
    telescope = true,
    cmp = true,
    noice = true,
    lsp = true,
    notify = true,
  },
}

--- Update a config value and trigger theme reload
---@param key string The config key to update
---@param value any The new value
function M.set(key, value)
  M[key] = value
  -- Trigger reload after a brief delay to allow the change to settle
  vim.schedule(function()
    require("copper.theme").reload()
  end)
end

--- Get border characters for current border style
---@return table Border characters array
function M.get_border_chars()
  return M.border_chars[M.borders]
end

return M

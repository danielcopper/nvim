-- Utility functions for theme system

local M = {}

--- Create a simple border highlight
---@param fg string Foreground color
---@param bg string Background color
---@return table Highlight definition
function M.border_hl(fg, bg)
  return { fg = fg, bg = bg }
end

--- Create a title highlight with bold text
---@param fg string Foreground color
---@param bg string Background color
---@return table Highlight definition
function M.title_hl(fg, bg)
  return { fg = fg, bg = bg, bold = true }
end

--- Lighten a hex color by a percentage
---@param hex string Hex color (e.g. "#rrggbb")
---@param percent number Percentage to lighten (0-100)
---@return string Lightened hex color
function M.lighten(hex, percent)
  -- Simple implementation - can be enhanced
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)

  local amount = percent / 100
  r = math.min(255, math.floor(r + (255 - r) * amount))
  g = math.min(255, math.floor(g + (255 - g) * amount))
  b = math.min(255, math.floor(b + (255 - b) * amount))

  return string.format("#%02x%02x%02x", r, g, b)
end

--- Darken a hex color by a percentage
---@param hex string Hex color (e.g. "#rrggbb")
---@param percent number Percentage to darken (0-100)
---@return string Darkened hex color
function M.darken(hex, percent)
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)

  local amount = percent / 100
  r = math.floor(r * (1 - amount))
  g = math.floor(g * (1 - amount))
  b = math.floor(b * (1 - amount))

  return string.format("#%02x%02x%02x", r, g, b)
end

return M

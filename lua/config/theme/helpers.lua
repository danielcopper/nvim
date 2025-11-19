-- Theme helper functions
-- Transform theme settings into plugin-usable values
-- All functions here consume settings and produce output

local settings = require("config.theme.settings")
local M = {}

-- ============================================================================
-- Border Helpers
-- ============================================================================

--- Get border style as string
--- Used by plugins that accept border as string (most plugins)
--- @return string Border style ("none", "rounded", "single", "double")
function M.get_border()
  return settings.borders
end

--- Get border or empty table for "none"
--- Some plugins (LSP handlers, diagnostics) need empty table instead of "none"
--- @return string|table Border style or empty table
function M.get_border_or_empty()
  return settings.borders == "none" and {} or settings.borders
end

--- Get telescope borderchars (8-element array)
--- Telescope uses a specific 8-element array format for borders
--- Order: top, right, bottom, left, top-left, top-right, bottom-right, bottom-left
--- @return table 8-element array of border characters
function M.get_telescope_borderchars()
  if settings.borders == "none" then
    return { " ", " ", " ", " ", " ", " ", " ", " " }
  elseif settings.borders == "rounded" then
    return { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  elseif settings.borders == "single" then
    return { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
  elseif settings.borders == "double" then
    return { "═", "║", "═", "║", "╔", "╗", "╝", "╚" }
  else
    -- Default to rounded if unknown border style
    return { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  end
end

-- ============================================================================
-- Settings Access Helpers
-- ============================================================================

--- Get colorscheme name
--- @return string Colorscheme name
function M.get_colorscheme_name()
  return settings.colorscheme.name
end

--- Get colorscheme variant
--- @return string Colorscheme variant
function M.get_colorscheme_variant()
  return settings.colorscheme.variant
end

--- Get dim_inactive setting
--- @return boolean Whether to dim inactive windows
function M.get_dim_inactive()
  return settings.dim_inactive
end

-- ============================================================================
-- Color Palette Helpers
-- ============================================================================

--- Get color palette based on current colorscheme
--- Returns the colorscheme's palette for applying theme colors
--- @return table|nil Palette table for catppuccin, nil for other colorschemes
function M.get_palette()
  if settings.colorscheme.name == "catppuccin" then
    return require("catppuccin.palettes").get_palette(settings.colorscheme.variant or "mocha")
  else
    return nil  -- Use defaults for other colorschemes
  end
end

return M

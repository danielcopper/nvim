-- Color extraction from different colorschemes
-- Translates colorscheme-specific colors to standardized names

local M = {}

--- Main extraction function - dispatches to colorscheme-specific extractors
---@return table Standardized color table
function M.extract()
  local colorscheme = vim.g.colors_name or "default"

  -- Dispatch to appropriate extractor
  if colorscheme == "catppuccin" then
    return M.extract_catppuccin()
  elseif colorscheme == "kanso" then
    return M.extract_kanso()
  else
    return M.extract_generic()
  end
end

--- Extract colors from Catppuccin theme
---@return table Standardized color table
function M.extract_catppuccin()
  local ok, cp_palettes = pcall(require, "catppuccin.palettes")
  if not ok then
    return M.extract_generic()
  end

  local palette = cp_palettes.get_palette() -- Gets current flavor (mocha, latte, etc.)

  -- Map Catppuccin colors to standardized names
  return {
    -- Backgrounds (from darkest to lightest)
    bg_darker = palette.crust, -- Darkest background
    bg_dark = palette.mantle, -- Dark background
    bg = palette.base, -- Normal background
    bg_light = palette.surface0, -- Light background
    bg_lighter = palette.surface1, -- Lighter background
    bg_highlight = palette.surface2, -- Highlight background

    -- Foregrounds
    fg = palette.text, -- Normal text
    fg_dim = palette.subtext1, -- Dimmed text
    fg_dimmer = palette.subtext0, -- More dimmed text
    fg_comment = palette.overlay2, -- Comments

    -- Borders
    border = palette.surface1, -- Normal border
    border_highlight = palette.lavender, -- Highlighted border

    -- Accent colors
    blue = palette.blue,
    cyan = palette.teal,
    green = palette.green,
    yellow = palette.yellow,
    orange = palette.peach,
    red = palette.red,
    purple = palette.mauve,
    pink = palette.pink,

    -- Special
    none = "NONE",
  }
end

--- Extract colors from Kanso theme
---@return table Standardized color table
function M.extract_kanso()
  -- Kanso doesn't export its palette directly, so we extract from highlights
  -- You can customize this based on Kanso's actual color system
  local function get_hl_color(group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    if hl[attr] then
      return string.format("#%06x", hl[attr])
    end
    return nil
  end

  return {
    -- Backgrounds
    bg_darker = get_hl_color("CursorLine", "bg") or "#000000",
    bg_dark = get_hl_color("NormalFloat", "bg") or "#0a0a0a",
    bg = get_hl_color("Normal", "bg") or "#101010",
    bg_light = get_hl_color("Visual", "bg") or "#1a1a1a",
    bg_lighter = get_hl_color("StatusLine", "bg") or "#202020",
    bg_highlight = get_hl_color("CursorLine", "bg") or "#252525",

    -- Foregrounds
    fg = get_hl_color("Normal", "fg") or "#ffffff",
    fg_dim = get_hl_color("Comment", "fg") or "#888888",
    fg_dimmer = get_hl_color("NonText", "fg") or "#666666",
    fg_comment = get_hl_color("Comment", "fg") or "#666666",

    -- Borders
    border = get_hl_color("FloatBorder", "fg") or "#444444",
    border_highlight = get_hl_color("IncSearch", "bg") or "#666666",

    -- Accent colors
    blue = get_hl_color("Function", "fg") or "#61afef",
    cyan = get_hl_color("Identifier", "fg") or "#56b6c2",
    green = get_hl_color("String", "fg") or "#98c379",
    yellow = get_hl_color("Number", "fg") or "#e5c07b",
    orange = get_hl_color("Constant", "fg") or "#d19a66",
    red = get_hl_color("Error", "fg") or "#e06c75",
    purple = get_hl_color("Statement", "fg") or "#c678dd",
    pink = get_hl_color("Special", "fg") or "#e06c75",

    -- Special
    none = "NONE",
  }
end

--- Generic fallback extractor - works with any colorscheme
---@return table Standardized color table
function M.extract_generic()
  local function get_hl_color(group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    if hl[attr] then
      return string.format("#%06x", hl[attr])
    end
    return nil
  end

  -- Best-effort extraction from common highlight groups
  return {
    -- Backgrounds
    bg_darker = get_hl_color("CursorLine", "bg") or "#000000",
    bg_dark = get_hl_color("NormalFloat", "bg") or "#0a0a0a",
    bg = get_hl_color("Normal", "bg") or "#000000",
    bg_light = get_hl_color("Visual", "bg") or "#1a1a1a",
    bg_lighter = get_hl_color("Pmenu", "bg") or "#202020",
    bg_highlight = get_hl_color("CursorLine", "bg") or "#1a1a1a",

    -- Foregrounds
    fg = get_hl_color("Normal", "fg") or "#ffffff",
    fg_dim = get_hl_color("Comment", "fg") or "#808080",
    fg_dimmer = get_hl_color("NonText", "fg") or "#606060",
    fg_comment = get_hl_color("Comment", "fg") or "#808080",

    -- Borders
    border = get_hl_color("FloatBorder", "fg") or "#404040",
    border_highlight = get_hl_color("IncSearch", "bg") or "#606060",

    -- Accent colors (extract from syntax highlighting)
    blue = get_hl_color("Function", "fg") or "#61afef",
    cyan = get_hl_color("Identifier", "fg") or "#56b6c2",
    green = get_hl_color("String", "fg") or "#98c379",
    yellow = get_hl_color("Number", "fg") or "#e5c07b",
    orange = get_hl_color("Constant", "fg") or "#d19a66",
    red = get_hl_color("Error", "fg") or "#e06c75",
    purple = get_hl_color("Statement", "fg") or "#c678dd",
    pink = get_hl_color("Special", "fg") or "#e06c75",

    -- Special
    none = "NONE",
  }
end

return M

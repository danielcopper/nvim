-- Theme settings
-- Single source of truth for all theme-related configuration
-- This file contains only data, no logic

local M = {}

-- ============================================================================
-- Theme Settings (Change these to switch theme)
-- ============================================================================

-- Colorscheme configuration
M.colorscheme = {
  name = "catppuccin", -- "catppuccin" | "rose-pine" | "kanagawa" | etc.
  variant = "mocha",   -- colorscheme-specific variant
  -- name = "rose-pine", -- "catppuccin" | "rose-pine" | "kanagawa" | etc.
  -- variant = "main",   -- colorscheme-specific variant
  -- catppuccin: "latte" | "frappe" | "macchiato" | "mocha"
  -- rose-pine: "main" | "moon" | "dawn"
  -- kanagawa: "wave" | "dragon" | "lotus"

  -- Catppuccin-specific custom colors
  catppuccin_alt_bg = "#1c1c2b", -- Alternative bg (between base #1e1e2e and mantle #181825)
}

-- Border style for floating windows
M.borders = "none" -- "none" | "rounded" | "single" | "double"

-- Dim inactive windows
M.dim_inactive = true -- true | false

-- Transparency (for future use)
M.transparency = {
  enabled = false,
}

return M

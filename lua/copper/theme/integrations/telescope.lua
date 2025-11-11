-- Telescope integration
-- Generates telescope highlights based on colors and border style

local M = {}

--- Generate telescope highlights
---@param colors table Standardized color table
---@param config table Theme config
---@param icons table Icons table
---@return table Highlight definitions
function M.get(colors, config, icons)
  local highlights = {}

  if config.borders == "none" then
    -- BORDERLESS MODE: Use different subtle backgrounds for visual separation
    -- This creates the NvChad-style appearance with no visible borders

    -- Prompt section (where you type the search)
    highlights.TelescopePromptNormal = { bg = colors.bg_light }
    highlights.TelescopePromptBorder = { bg = colors.bg_light, fg = colors.bg_light }
    highlights.TelescopePromptTitle = { bg = colors.bg_light, fg = colors.bg_light }
    highlights.TelescopePromptPrefix = { bg = colors.bg_light, fg = colors.blue }

    -- Results section (file list)
    highlights.TelescopeResultsNormal = { bg = colors.bg_dark }
    highlights.TelescopeResultsBorder = { bg = colors.bg_dark, fg = colors.bg_dark }
    highlights.TelescopeResultsTitle = { bg = colors.bg_dark, fg = colors.bg_dark }

    -- Preview section (file contents)
    highlights.TelescopePreviewNormal = { bg = colors.bg_darker }
    highlights.TelescopePreviewBorder = { bg = colors.bg_darker, fg = colors.bg_darker }
    highlights.TelescopePreviewTitle = { bg = colors.bg_darker, fg = colors.bg_darker }

    -- Selection highlight
    highlights.TelescopeSelection = { bg = colors.bg_lighter, fg = colors.fg, bold = true }
    highlights.TelescopeSelectionCaret = { fg = colors.blue, bg = colors.bg_lighter }

  else
    -- BORDERED MODE: Use visible borders with colored titles
    local bg = colors.bg
    local border_color = colors.border

    -- Prompt section
    highlights.TelescopePromptNormal = { bg = bg }
    highlights.TelescopePromptBorder = { bg = bg, fg = border_color }
    highlights.TelescopePromptTitle = { bg = colors.blue, fg = bg, bold = true }
    highlights.TelescopePromptPrefix = { bg = bg, fg = colors.blue }

    -- Results section
    highlights.TelescopeResultsNormal = { bg = bg }
    highlights.TelescopeResultsBorder = { bg = bg, fg = border_color }
    highlights.TelescopeResultsTitle = { bg = colors.green, fg = bg, bold = true }

    -- Preview section
    highlights.TelescopePreviewNormal = { bg = bg }
    highlights.TelescopePreviewBorder = { bg = bg, fg = border_color }
    highlights.TelescopePreviewTitle = { bg = colors.purple, fg = bg, bold = true }

    -- Selection highlight
    highlights.TelescopeSelection = { bg = colors.bg_light, fg = colors.fg, bold = true }
    highlights.TelescopeSelectionCaret = { fg = colors.blue, bg = colors.bg_light }
  end

  -- Common highlights (apply to both modes)
  highlights.TelescopeMatching = { fg = colors.cyan, bold = true }
  highlights.TelescopeMultiSelection = { fg = colors.purple }

  return highlights
end

return M

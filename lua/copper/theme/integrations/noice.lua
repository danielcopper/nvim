-- Noice integration
-- Generates highlights for noice UI elements (hover, signature, etc.)

local M = {}

--- Generate noice highlights
---@param colors table Standardized color table
---@param config table Theme config
---@param icons table Icons table
---@return table Highlight definitions
function M.get(colors, config, icons)
  local highlights = {}

  -- Noice popup/floating windows
  highlights.NoicePopup = { bg = colors.bg }
  highlights.NoicePopupBorder = { fg = colors.border, bg = colors.bg }

  -- Command line
  highlights.NoiceCmdline = { bg = colors.bg }
  highlights.NoiceCmdlineBorder = { fg = colors.border, bg = colors.bg }
  highlights.NoiceCmdlineIcon = { fg = colors.blue }
  highlights.NoiceCmdlinePopup = { bg = colors.bg }
  highlights.NoiceCmdlinePopupBorder = { fg = colors.border, bg = colors.bg }

  -- Confirm popup
  highlights.NoiceConfirm = { bg = colors.bg }
  highlights.NoiceConfirmBorder = { fg = colors.border, bg = colors.bg }

  -- LSP-related
  highlights.NoiceLspProgressTitle = { fg = colors.blue }
  highlights.NoiceLspProgressClient = { fg = colors.purple }

  -- Messages
  highlights.NoiceMini = { bg = colors.bg_dark }

  return highlights
end

return M

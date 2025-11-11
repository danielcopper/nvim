-- nvim-cmp integration
-- Generates completion menu highlights

local M = {}

--- Generate cmp highlights
---@param colors table Standardized color table
---@param config table Theme config
---@param icons table Icons table
---@return table Highlight definitions
function M.get(colors, config, icons)
  local highlights = {}

  -- Completion menu
  highlights.CmpNormal = { bg = colors.bg }
  highlights.CmpBorder = { fg = colors.border, bg = colors.bg }
  highlights.CmpCursorLine = { bg = colors.bg_light }
  highlights.CmpSelection = { bg = colors.bg_light, fg = colors.fg, bold = true }

  -- Documentation window
  highlights.CmpDocNormal = { bg = colors.bg }
  highlights.CmpDocBorder = { fg = colors.border, bg = colors.bg }

  -- Item kinds (styled based on LSP kind icons)
  highlights.CmpItemKindDefault = { fg = colors.fg }
  highlights.CmpItemKindFunction = { fg = colors.purple }
  highlights.CmpItemKindMethod = { fg = colors.purple }
  highlights.CmpItemKindConstructor = { fg = colors.blue }
  highlights.CmpItemKindField = { fg = colors.blue }
  highlights.CmpItemKindVariable = { fg = colors.cyan }
  highlights.CmpItemKindClass = { fg = colors.yellow }
  highlights.CmpItemKindInterface = { fg = colors.yellow }
  highlights.CmpItemKindModule = { fg = colors.orange }
  highlights.CmpItemKindProperty = { fg = colors.blue }
  highlights.CmpItemKindKeyword = { fg = colors.red }
  highlights.CmpItemKindSnippet = { fg = colors.green }
  highlights.CmpItemKindText = { fg = colors.fg_dim }
  highlights.CmpItemKindFile = { fg = colors.fg }
  highlights.CmpItemKindFolder = { fg = colors.blue }

  -- Item appearance
  highlights.CmpItemAbbr = { fg = colors.fg }
  highlights.CmpItemAbbrMatch = { fg = colors.cyan, bold = true }
  highlights.CmpItemAbbrMatchFuzzy = { fg = colors.cyan }
  highlights.CmpItemMenu = { fg = colors.fg_dim }

  return highlights
end

return M

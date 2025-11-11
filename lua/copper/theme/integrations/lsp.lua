-- LSP integration
-- Generates diagnostic and LSP-related highlights

local M = {}

--- Generate LSP highlights
---@param colors table Standardized color table
---@param config table Theme config
---@param icons table Icons table
---@return table Highlight definitions
function M.get(colors, config, icons)
  local highlights = {}

  -- Diagnostic virtual text
  highlights.DiagnosticError = { fg = colors.red }
  highlights.DiagnosticWarn = { fg = colors.yellow }
  highlights.DiagnosticInfo = { fg = colors.cyan }
  highlights.DiagnosticHint = { fg = colors.blue }

  -- Diagnostic underlines
  highlights.DiagnosticUnderlineError = { undercurl = true, sp = colors.red }
  highlights.DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow }
  highlights.DiagnosticUnderlineInfo = { undercurl = true, sp = colors.cyan }
  highlights.DiagnosticUnderlineHint = { undercurl = true, sp = colors.blue }

  -- Diagnostic signs (used in sign column)
  highlights.DiagnosticSignError = { fg = colors.red }
  highlights.DiagnosticSignWarn = { fg = colors.yellow }
  highlights.DiagnosticSignInfo = { fg = colors.cyan }
  highlights.DiagnosticSignHint = { fg = colors.blue }

  -- Diagnostic floating window
  highlights.DiagnosticFloatingError = { fg = colors.red }
  highlights.DiagnosticFloatingWarn = { fg = colors.yellow }
  highlights.DiagnosticFloatingInfo = { fg = colors.cyan }
  highlights.DiagnosticFloatingHint = { fg = colors.blue }

  -- LSP references/definitions
  highlights.LspReferenceText = { bg = colors.bg_light }
  highlights.LspReferenceRead = { bg = colors.bg_light }
  highlights.LspReferenceWrite = { bg = colors.bg_light, bold = true }

  -- LSP signature help
  highlights.LspSignatureActiveParameter = { fg = colors.blue, bold = true }

  -- Inlay hints
  highlights.LspInlayHint = { fg = colors.fg_dimmer, italic = true }

  return highlights
end

return M

-- nvim-notify integration
-- Only sets backgrounds when borderless mode is active

local M = {}

--- Generate notify highlights
---@param colors table Standardized color table
---@param config table Theme config
---@param icons table Icons table
---@return table Highlight definitions
function M.get(colors, config, icons)
  local highlights = {}

  -- Only override when borders are "none"
  -- Otherwise, use nvim-notify's defaults
  if config.borders == "none" then
    -- Use same background as telescope results (file list)
    local bg = colors.bg_dark

    -- Set window background (this fills the entire notification area)
    highlights.NotifyBackground = { bg = bg }

    -- Set Icon backgrounds
    highlights.NotifyERRORIcon = { bg = bg, fg = colors.red }
    highlights.NotifyWARNIcon = { bg = bg, fg = colors.yellow }
    highlights.NotifyINFOIcon = { bg = bg, fg = colors.blue }
    highlights.NotifyDEBUGIcon = { bg = bg, fg = colors.fg_comment }
    highlights.NotifyTRACEIcon = { bg = bg, fg = colors.purple }

    -- Set Title backgrounds
    highlights.NotifyERRORTitle = { bg = bg, fg = colors.red }
    highlights.NotifyWARNTitle = { bg = bg, fg = colors.yellow }
    highlights.NotifyINFOTitle = { bg = bg, fg = colors.blue }
    highlights.NotifyDEBUGTitle = { bg = bg, fg = colors.fg_comment }
    highlights.NotifyTRACETitle = { bg = bg, fg = colors.purple }

    -- Set Body backgrounds
    highlights.NotifyERRORBody = { bg = bg, fg = colors.red }
    highlights.NotifyWARNBody = { bg = bg, fg = colors.yellow }
    highlights.NotifyINFOBody = { bg = bg, fg = colors.green }
    highlights.NotifyDEBUGBody = { bg = bg, fg = colors.fg_comment }
    highlights.NotifyTRACEBody = { bg = bg, fg = colors.purple }

    -- Make borders invisible by matching background
    highlights.NotifyERRORBorder = { fg = bg, bg = bg }
    highlights.NotifyWARNBorder = { fg = bg, bg = bg }
    highlights.NotifyINFOBorder = { fg = bg, bg = bg }
    highlights.NotifyDEBUGBorder = { fg = bg, bg = bg }
    highlights.NotifyTRACEBorder = { fg = bg, bg = bg }
  end

  return highlights
end

return M

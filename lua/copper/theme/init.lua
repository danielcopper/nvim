-- Main theme engine
-- Orchestrates color extraction, integration loading, and highlight application

local M = {}

--- Get current theme configuration
---@return table Theme config
function M.get_config()
  return require("copper.theme.config")
end

--- Get colors for current colorscheme
---@return table Standardized color table
function M.get_colors()
  return require("copper.theme.colors").extract()
end

--- Get centralized icons
---@return table Icons table
function M.get_icons()
  return require("copper.theme.icons")
end

--- Apply a table of highlights to Neovim
---@param highlights table Table of highlight group definitions
function M.apply_highlights(highlights)
  for group_name, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group_name, opts)
  end
end

--- Load and apply a single integration
---@param name string Integration name (telescope, cmp, noice, lsp)
function M.load_integration(name)
  local config = M.get_config()

  -- Check if integration is enabled
  if not config.integrations[name] then
    return
  end

  -- Load integration module
  local ok, integration = pcall(require, "copper.theme.integrations." .. name)
  if not ok then
    vim.notify(
      string.format("Failed to load theme integration: %s", name),
      vim.log.levels.WARN
    )
    return
  end

  -- Generate highlights by passing colors, config, and icons to integration
  local colors = M.get_colors()
  local icons = M.get_icons()
  local highlights = integration.get(colors, config, icons)

  -- Apply highlights
  M.apply_highlights(highlights)

  -- Refresh notify windows if this is the notify integration
  if name == "notify" then
    vim.schedule(function()
      -- Redraw all notify windows to pick up new highlights
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "notify" then
            vim.api.nvim_win_call(win, function()
              vim.cmd("redraw")
            end)
          end
        end
      end
    end)
  end
end

--- Reload all theme integrations
function M.reload()
  -- Clear module cache for theme modules to pick up any changes
  package.loaded["copper.theme.config"] = nil
  package.loaded["copper.theme.colors"] = nil
  package.loaded["copper.theme.icons"] = nil

  local config = M.get_config()

  -- Clear integration module cache
  for name, _ in pairs(config.integrations) do
    package.loaded["copper.theme.integrations." .. name] = nil
  end

  -- Reload all enabled integrations
  for name, enabled in pairs(config.integrations) do
    if enabled then
      M.load_integration(name)
    end
  end

  -- Fire custom autocmd for other plugins that might want to react
  vim.api.nvim_exec_autocmds("User", {
    pattern = "CopperThemeReload",
    modeline = false,
  })

  vim.notify("Theme reloaded", vim.log.levels.INFO)
end

--- Initialize theme system
function M.setup()
  -- Create autocmd group for theme management
  local group = vim.api.nvim_create_augroup("CopperTheme", { clear = true })

  -- Auto-reload when colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      -- Schedule to avoid potential race conditions
      vim.schedule(function()
        M.reload()
      end)
    end,
    desc = "Reload theme integrations on colorscheme change",
  })

  -- Initial load of all integrations
  vim.schedule(function()
    M.reload()
  end)
end

return M

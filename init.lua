-- TODO:
-- theming system
-- lsp integration improvements in lualine
--  - doenst work properly when restargin lsp
--  - should have a cog symbol in front and maybe slightly colored
-- Load environment variables from .env file (for codecompanion API keys)
-- color preview
local function load_env()
  local env_file = vim.fn.stdpath("config") .. "/.env"
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      -- Skip empty lines and comments
      if line:match("^%s*$") == nil and line:match("^%s*#") == nil then
        local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
        if key and value then
          -- Remove quotes if present
          value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
          vim.env[key] = value
        end
      end
    end
  end
end
load_env()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core config (options sets leader keys)
require("config.options")

-- Setup plugins
require("lazy").setup({
    spec = { { import = "plugins" } },
    install = { colorscheme = { "catppuccin", "habamax" } },
    checker = { enabled = true, notify = false },
    change_detection = { enabled = true, notify = false },
    -- ui = { border = "rounded" },
})

-- Load keymaps and autocmds
require("config.keymaps")
require("config.autocmds")

-- Initialize theme system
require("copper.theme").setup()

-- Theme management user commands
vim.api.nvim_create_user_command("ThemeBorders", function(opts)
  require("copper.theme.config").set("borders", opts.args)
end, {
  nargs = 1,
  complete = function()
    return { "none", "single", "rounded", "double" }
  end,
  desc = "Set border style (none|single|rounded|double)",
})

vim.api.nvim_create_user_command("ThemeReload", function()
  require("copper.theme").reload()
end, {
  desc = "Manually reload theme system",
})

vim.api.nvim_create_user_command("ThemeInfo", function()
  local config = require("copper.theme.config")
  local colors = require("copper.theme").get_colors()

  print("=== Theme Info ===")
  print("Colorscheme: " .. (vim.g.colors_name or "none"))
  print("Border style: " .. config.borders)
  print("Transparency: " .. tostring(config.transparency))
  print("\nColors:")
  for k, v in pairs(colors) do
    print(string.format("  %s = %s", k, v))
  end
end, {
  desc = "Show current theme information",
})

vim.api.nvim_create_user_command("ThemeToggleBorders", function()
  local config = require("copper.theme.config")
  local styles = { "none", "single", "rounded", "double" }
  local current_index = 1

  for i, style in ipairs(styles) do
    if style == config.borders then
      current_index = i
      break
    end
  end

  local next_index = (current_index % #styles) + 1
  local next_style = styles[next_index]

  config.set("borders", next_style)
  vim.notify("Borders: " .. next_style, vim.log.levels.INFO)
end, {
  desc = "Cycle through border styles",
})

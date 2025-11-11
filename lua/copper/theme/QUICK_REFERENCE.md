# Theme System Quick Reference

Fast lookup guide for common operations.

## User Commands

```vim
:ThemeBorders <style>      " Set border: none, single, rounded, double
:ThemeToggleBorders        " Cycle through border styles
:ThemeInfo                 " Show current theme info
:ThemeReload               " Manually reload theme
```

## Lua API

### Config Access

```lua
local config = require("copper.theme.config")

-- Get current settings
config.borders           -- "none" | "single" | "rounded" | "double"
config.padding           -- { vertical, horizontal }
config.transparency      -- boolean
config.colorscheme       -- string

-- Get border characters
config.get_border_chars() -- Returns table for telescope

-- Change settings (triggers reload)
config.set("borders", "rounded")
config.set("padding", { 1, 2 })
```

### Icon Access

```lua
local icons = require("copper.theme.icons")

-- LSP Kinds
icons.kinds.Function       -- "󰊕"
icons.kinds.Variable       -- "󰀫"
icons.kinds.Class          -- "󰠱"

-- Diagnostics
icons.diagnostics.Error    -- "󰅚"
icons.diagnostics.Warn     -- "󰀪"
icons.diagnostics.Hint     -- "󰌶"
icons.diagnostics.Info     -- ""

-- Git
icons.git.Add              -- ""
icons.git.Modify           -- ""
icons.git.Delete           -- ""

-- DAP
icons.dap.Breakpoint       -- ""
icons.dap.Stopped          -- "󰁕"

-- UI
icons.ui.Folder            -- "󰉋"
icons.ui.Search            -- ""
icons.ui.Close             -- "󰅖"
```

### Color Access

```lua
local theme = require("copper.theme")
local colors = theme.get_colors()

-- Backgrounds
colors.bg_darker    -- Darkest
colors.bg_dark      -- Dark
colors.bg           -- Normal
colors.bg_light     -- Light
colors.bg_lighter   -- Lighter
colors.bg_highlight -- Highlight

-- Foregrounds
colors.fg           -- Normal text
colors.fg_dim       -- Dimmed
colors.fg_dimmer    -- More dimmed
colors.fg_comment   -- Comments

-- Borders
colors.border       -- Normal border
colors.border_highlight -- Highlighted

-- Accents
colors.blue, colors.cyan, colors.green
colors.yellow, colors.orange, colors.red
colors.purple, colors.pink

-- Special
colors.none         -- "NONE"
```

### Theme Engine

```lua
local theme = require("copper.theme")

-- Get config
theme.get_config()

-- Get colors
theme.get_colors()

-- Get icons
theme.get_icons()

-- Reload everything
theme.reload()

-- Load specific integration
theme.load_integration("telescope")

-- Apply custom highlights
theme.apply_highlights({
  MyGroup = { fg = "#ff0000", bold = true },
})
```

## Plugin Config Patterns

### Use Theme Borders

```lua
config = function()
  local theme_config = require("copper.theme.config")

  require("plugin").setup({
    border = theme_config.borders,
    -- or for telescope:
    borderchars = theme_config.get_border_chars(),
  })
end
```

### Use Theme Icons

```lua
config = function()
  local icons = require("copper.theme.icons")

  require("plugin").setup({
    icons = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
    },
  })
end
```

### Use Theme Colors

```lua
config = function()
  local colors = require("copper.theme").get_colors()

  require("plugin").setup({
    colors = {
      primary = colors.blue,
      secondary = colors.purple,
    },
  })
end
```

## Integration Template

```lua
-- lua/copper/theme/integrations/myplugin.lua
local M = {}

function M.get(colors, config, icons)
  local highlights = {}

  -- Basic
  highlights.MyPlugin = { fg = colors.fg, bg = colors.bg }

  -- Border-aware
  if config.borders == "none" then
    highlights.MyPluginBorder = { fg = colors.bg, bg = colors.bg }
  else
    highlights.MyPluginBorder = { fg = colors.border }
  end

  -- States
  highlights.MyPluginError = { fg = colors.red }
  highlights.MyPluginWarn = { fg = colors.yellow }
  highlights.MyPluginOk = { fg = colors.green }

  return highlights
end

return M
```

## Colorscheme Extraction Template

```lua
-- In lua/copper/theme/colors.lua

function M.extract_mycolorscheme()
  -- Try theme API
  local ok, palette = pcall(require, "mycolorscheme.colors")
  if not ok then return M.extract_generic() end

  -- Map to standard colors
  return {
    bg_darker = palette.bg_dark,
    bg_dark = palette.bg,
    bg = palette.bg,
    bg_light = palette.bg_light,
    bg_lighter = palette.bg_lighter,
    bg_highlight = palette.bg_visual,

    fg = palette.fg,
    fg_dim = palette.fg_dark,
    fg_dimmer = palette.fg_darker,
    fg_comment = palette.comment,

    border = palette.border,
    border_highlight = palette.border_highlight,

    blue = palette.blue,
    cyan = palette.cyan,
    green = palette.green,
    yellow = palette.yellow,
    orange = palette.orange,
    red = palette.red,
    purple = palette.purple,
    pink = palette.magenta,

    none = "NONE",
  }
end

-- Add to dispatcher
function M.extract()
  local colorscheme = vim.g.colors_name or "default"

  if colorscheme == "mycolorscheme" then
    return M.extract_mycolorscheme()
  end
  -- ... other colorschemes
end
```

## Common Highlight Patterns

### Standard Highlight

```lua
MyGroup = { fg = colors.blue, bg = colors.bg }
```

### Bold/Italic

```lua
MyGroup = { fg = colors.green, bold = true, italic = true }
```

### Underline

```lua
MyError = { fg = colors.red, underline = true }
MyError = { fg = colors.red, undercurl = true, sp = colors.red }
```

### Transparent

```lua
MyTransparent = { fg = colors.fg, bg = "NONE" }
-- or
MyTransparent = { fg = colors.fg, bg = colors.none }
```

### Link to Another Group

```lua
-- In Neovim API (not in integration files)
vim.api.nvim_set_hl(0, "MyGroup", { link = "Normal" })
```

## Keybinding Examples

```lua
-- In lua/config/keymaps.lua

-- Toggle borders
vim.keymap.set("n", "<leader>tb", "<cmd>ThemeToggleBorders<cr>",
  { desc = "Toggle borders" })

-- Cycle through specific styles
local styles = { "none", "single" }
local idx = 1
vim.keymap.set("n", "<leader>tB", function()
  idx = (idx % #styles) + 1
  vim.cmd("ThemeBorders " .. styles[idx])
end, { desc = "Toggle none/single" })

-- Show theme info
vim.keymap.set("n", "<leader>ti", "<cmd>ThemeInfo<cr>",
  { desc = "Theme info" })
```

## Autocmd Hooks

```lua
-- React to theme reload
vim.api.nvim_create_autocmd("User", {
  pattern = "CopperThemeReload",
  callback = function()
    -- Your code here
    print("Theme reloaded!")
  end,
})

-- Per-colorscheme customization
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colorscheme = vim.g.colors_name
    if colorscheme == "catppuccin" then
      -- Catppuccin-specific tweaks
    end
  end,
})
```

## Debugging

```vim
" Check colors
:lua vim.print(require("copper.theme").get_colors())

" Check config
:lua vim.print(require("copper.theme.config"))

" Check icons
:lua vim.print(require("copper.theme.icons").kinds)

" Check specific highlight
:lua vim.print(vim.api.nvim_get_hl(0, { name = "Normal" }))

" List all highlights with "Telescope"
:filter /Telescope/ hi

" Inspect highlight under cursor (Neovim 0.9+)
:Inspect
```

## File Locations

```
lua/copper/theme/
├── config.lua         - Main configuration
├── icons.lua          - Icon definitions
├── colors.lua         - Color extraction
├── init.lua           - Theme engine
└── integrations/      - Plugin integrations
    ├── telescope.lua
    ├── cmp.lua
    ├── noice.lua
    └── lsp.lua
```

## Related Plugin Configs

These plugins use the theme system:

- `lua/plugins/telescope.lua` - Borderchars
- `lua/plugins/completion.lua` - Borders + icons
- `lua/plugins/noice.lua` - Borders + padding
- `lua/plugins/lsp.lua` - Icons + borders
- `lua/config/options.lua` - Global winborder

# Extending the Theme System

Guide for adding new colorschemes, integrations, and customizations to the CopperVim theme system.

## Table of Contents

- [Adding a New Colorscheme](#adding-a-new-colorscheme)
- [Creating a New Integration](#creating-a-new-integration)
- [Adding Custom UI Settings](#adding-custom-ui-settings)
- [Advanced Customization](#advanced-customization)

## Adding a New Colorscheme

When you want to use a new colorscheme (e.g., "tokyonight", "gruvbox", "nord"), you need to teach the theme system how to extract colors from it.

### Step 1: Add Extraction Function

Edit `lua/copper/theme/colors.lua`:

```lua
--- Extract colors from TokyoNight theme
---@return table Standardized color table
function M.extract_tokyonight()
  -- Try to get colors from the colorscheme's API
  local ok, tokyonight_colors = pcall(require, "tokyonight.colors")
  if not ok then
    return M.extract_generic() -- Fallback
  end

  local colors = tokyonight_colors.setup()

  -- Map TokyoNight colors to standardized names
  return {
    -- Backgrounds (darkest to lightest)
    bg_darker = colors.bg_dark,
    bg_dark = colors.bg,
    bg = colors.bg,
    bg_light = colors.bg_highlight,
    bg_lighter = colors.bg_visual,
    bg_highlight = colors.bg_visual,

    -- Foregrounds
    fg = colors.fg,
    fg_dim = colors.fg_dark,
    fg_dimmer = colors.fg_gutter,
    fg_comment = colors.comment,

    -- Borders
    border = colors.border,
    border_highlight = colors.border_highlight,

    -- Accent colors
    blue = colors.blue,
    cyan = colors.cyan,
    green = colors.green,
    yellow = colors.yellow,
    orange = colors.orange,
    red = colors.red,
    purple = colors.purple,
    pink = colors.magenta,

    -- Special
    none = "NONE",
  }
end
```

### Step 2: Register in Dispatcher

Add to the `extract()` function in the same file:

```lua
function M.extract()
  local colorscheme = vim.g.colors_name or "default"

  if colorscheme == "catppuccin" then
    return M.extract_catppuccin()
  elseif colorscheme == "kanso" then
    return M.extract_kanso()
  elseif colorscheme == "tokyonight" then  -- Add this
    return M.extract_tokyonight()           -- Add this
  else
    return M.extract_generic()
  end
end
```

### Step 3: Test

```vim
:colorscheme tokyonight
:ThemeInfo  " Verify colors are extracted correctly
```

### Standardized Color Keys

Your extraction function MUST return these keys:

**Required:**
- `bg_darker`, `bg_dark`, `bg`, `bg_light`, `bg_lighter`, `bg_highlight`
- `fg`, `fg_dim`, `fg_dimmer`, `fg_comment`
- `border`, `border_highlight`
- `blue`, `cyan`, `green`, `yellow`, `orange`, `red`, `purple`, `pink`
- `none` (always `"NONE"`)

**Optional:** You can add more, but integrations may not use them.

### Tips for Finding Colors

**If the colorscheme exports a palette:**

```lua
-- Example: Many themes have this pattern
local ok, palette = pcall(require, "themename.palette")
if ok then
  return {
    bg = palette.background,
    fg = palette.foreground,
    -- ...
  }
end
```

**If you need to extract from highlights:**

```lua
local function get_hl_color(group, attr)
  local hl = vim.api.nvim_get_hl(0, { name = group })
  if hl[attr] then
    return string.format("#%06x", hl[attr])
  end
  return nil
end

return {
  bg = get_hl_color("Normal", "bg") or "#000000",
  fg = get_hl_color("Normal", "fg") or "#ffffff",
  blue = get_hl_color("Function", "fg") or "#61afef",
  -- ...
}
```

**Common highlight groups to extract from:**
- `Normal` → bg, fg
- `NormalFloat` → bg_dark
- `CursorLine` → bg_darker, bg_highlight
- `Visual` → bg_light
- `Comment` → fg_comment, fg_dim
- `FloatBorder` → border
- `Function` → blue
- `String` → green
- `Error` → red
- `Number` → yellow

## Creating a New Integration

Integrations apply theme styling to specific plugins.

### Step 1: Create Integration File

Create `lua/copper/theme/integrations/myplugin.lua`:

```lua
-- MyPlugin integration
-- Generates highlights for myplugin.nvim

local M = {}

--- Generate myplugin highlights
---@param colors table Standardized color table
---@param config table Theme config
---@param icons table Icons table
---@return table Highlight definitions
function M.get(colors, config, icons)
  local highlights = {}

  -- Basic highlights
  highlights.MyPluginNormal = { bg = colors.bg, fg = colors.fg }
  highlights.MyPluginBorder = { fg = colors.border, bg = colors.bg }

  -- Border-aware styling
  if config.borders == "none" then
    -- No visible borders: use background matching
    highlights.MyPluginBorder = {
      fg = colors.bg,
      bg = colors.bg,
    }
  else
    -- Visible borders
    highlights.MyPluginBorder = {
      fg = colors.border,
      bg = colors.bg,
    }
  end

  -- Use centralized icons
  highlights.MyPluginIcon = { fg = colors.blue }
  -- Icon character would be used in plugin config, not highlight

  -- Status indicators
  highlights.MyPluginError = { fg = colors.red }
  highlights.MyPluginWarning = { fg = colors.yellow }
  highlights.MyPluginSuccess = { fg = colors.green }

  return highlights
end

return M
```

### Step 2: Enable Integration

Edit `lua/copper/theme/config.lua`:

```lua
integrations = {
  telescope = true,
  cmp = true,
  noice = true,
  lsp = true,
  myplugin = true,  -- Add your integration
},
```

### Step 3: Test

```vim
:ThemeReload
:lua vim.print(vim.api.nvim_get_hl(0, { name = "MyPluginNormal" }))
```

### Integration Patterns

**Pattern 1: Simple Static Highlights**

```lua
function M.get(colors, config, icons)
  return {
    PluginFoo = { fg = colors.blue },
    PluginBar = { fg = colors.green, bold = true },
  }
end
```

**Pattern 2: Border-Aware**

```lua
function M.get(colors, config, icons)
  local highlights = {}

  if config.borders == "none" then
    -- Borderless styling
    highlights.PluginWindow = { bg = colors.bg_dark }
    highlights.PluginBorder = { fg = colors.bg_dark, bg = colors.bg_dark }
  else
    -- Bordered styling
    highlights.PluginWindow = { bg = colors.bg }
    highlights.PluginBorder = { fg = colors.border, bg = colors.bg }
  end

  return highlights
end
```

**Pattern 3: Colorscheme-Specific**

```lua
function M.get(colors, config, icons)
  local colorscheme = vim.g.colors_name
  local highlights = {}

  -- Different styling for different colorschemes
  if colorscheme == "catppuccin" then
    highlights.PluginSpecial = { fg = colors.pink, italic = true }
  else
    highlights.PluginSpecial = { fg = colors.purple }
  end

  return highlights
end
```

**Pattern 4: Using Custom Config**

```lua
function M.get(colors, config, icons)
  local highlights = {}

  -- Access padding from config
  local padding = config.padding or { 0, 1 }

  -- Access custom config values you added
  local custom_value = config.custom_setting or "default"

  highlights.PluginNormal = { bg = colors.bg, fg = colors.fg }
  -- Note: Padding is typically handled in plugin config, not highlights

  return highlights
end
```

### Highlight Group Reference

Common attribute keys:
- `fg` - Foreground color (hex string or "NONE")
- `bg` - Background color (hex string or "NONE")
- `bold` - Bold text (boolean)
- `italic` - Italic text (boolean)
- `underline` - Underline (boolean)
- `undercurl` - Curly underline (boolean)
- `sp` - Special color for undercurl (hex string)
- `strikethrough` - Strikethrough (boolean)
- `reverse` - Reverse fg/bg (boolean)

Example:

```lua
MyGroup = {
  fg = colors.blue,
  bg = colors.bg_dark,
  bold = true,
  italic = true,
}
```

## Adding Custom UI Settings

You can extend the config to store additional UI preferences.

### Step 1: Add to Config

Edit `lua/copper/theme/config.lua`:

```lua
local M = {
  colorscheme = "catppuccin",
  borders = "none",
  transparency = false,
  padding = { 0, 1 },

  -- Add your custom settings
  completion_menu_height = 15,
  hover_max_width = 80,
  custom_feature = true,

  -- ... rest of config
}
```

### Step 2: Use in Integrations

```lua
-- In an integration file
function M.get(colors, config, icons)
  local highlights = {}

  -- Access your custom setting
  if config.custom_feature then
    highlights.Something = { fg = colors.blue }
  end

  return highlights
end
```

### Step 3: Use in Plugin Configs

```lua
-- In lua/plugins/myplugin.lua
config = function()
  local theme_config = require("copper.theme.config")

  require("myplugin").setup({
    height = theme_config.completion_menu_height,
    max_width = theme_config.hover_max_width,
  })
end
```

### Step 4: Create User Command (Optional)

```lua
-- In init.lua
vim.api.nvim_create_user_command("ThemeSetFeature", function(opts)
  local value = opts.args == "true"
  require("copper.theme.config").set("custom_feature", value)
end, {
  nargs = 1,
  desc = "Toggle custom feature",
})
```

## Advanced Customization

### Custom Icon Sets

Edit `lua/copper/theme/icons.lua`:

```lua
-- Add a new icon category
M.my_icons = {
  special = "",
  magic = "",
  rocket = "",
}
```

Use in configs:

```lua
local icons = require("copper.theme.icons")
local my_icon = icons.my_icons.rocket
```

### Dynamic Padding Based on Border

```lua
-- In config.lua
function M.get_padding()
  if M.borders == "none" then
    return { 0, 1 }  -- Less padding for borderless
  else
    return { 1, 2 }  -- More padding with borders
  end
end
```

Use in integrations:

```lua
function M.get(colors, config, icons)
  local padding = config.get_padding and config.get_padding() or config.padding
  -- Use padding value
end
```

### Color Transformations

Use utilities from `utils.lua`:

```lua
local utils = require("copper.theme.utils")

function M.get(colors, config, icons)
  return {
    Dimmed = { fg = utils.darken(colors.fg, 30) },  -- 30% darker
    Bright = { fg = utils.lighten(colors.bg, 20) }, -- 20% lighter
  }
end
```

### Conditional Loading

Disable an integration based on conditions:

```lua
-- In init.lua after theme setup
local theme_config = require("copper.theme.config")

-- Disable telescope integration at runtime
theme_config.integrations.telescope = false
require("copper.theme").reload()
```

### Custom Reload Hooks

React to theme changes:

```lua
-- In any plugin config
vim.api.nvim_create_autocmd("User", {
  pattern = "CopperThemeReload",
  callback = function()
    -- Do something when theme reloads
    print("Theme reloaded!")
    require("myplugin").refresh_colors()
  end,
})
```

### Override Integration Highlights

After theme applies highlights, override specific ones:

```lua
-- In init.lua after theme.setup()
vim.api.nvim_create_autocmd("User", {
  pattern = "CopperThemeReload",
  callback = function()
    -- Override after theme applies
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", {
      fg = "#ff0000",  -- Force red border
    })
  end,
})
```

### Per-Filetype Theming

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local colors = require("copper.theme").get_colors()
    -- Apply markdown-specific highlights
    vim.api.nvim_set_hl(0, "markdownH1", {
      fg = colors.blue,
      bold = true,
    })
  end,
})
```

## Testing Your Changes

### Verify Color Extraction

```vim
:lua vim.print(require("copper.theme").get_colors())
```

### Check Integration Output

```lua
:lua vim.print(require("copper.theme.integrations.telescope").get(
  require("copper.theme").get_colors(),
  require("copper.theme.config"),
  require("copper.theme.icons")
))
```

### Debug Highlight Groups

```vim
:Telescope highlights    " Search and preview all highlights
:Inspect                 " Show highlight under cursor (Neovim 0.9+)
```

### Reload Workflow

```vim
:e lua/copper/theme/integrations/myintegration.lua  " Edit
:w                                                   " Save
:ThemeReload                                         " Reload
```

## Common Pitfalls

### 1. Forgetting to Return Highlights

```lua
-- ❌ Wrong
function M.get(colors, config, icons)
  local highlights = {}
  highlights.Foo = { fg = colors.blue }
  -- Missing return!
end

-- ✅ Correct
function M.get(colors, config, icons)
  local highlights = {}
  highlights.Foo = { fg = colors.blue }
  return highlights
end
```

### 2. Using Wrong Color Keys

```lua
-- ❌ Wrong - "foreground" doesn't exist
highlights.Foo = { fg = colors.foreground }

-- ✅ Correct - use standardized "fg"
highlights.Foo = { fg = colors.fg }
```

### 3. Not Handling Border = "none"

```lua
-- ❌ Wrong - doesn't adapt to borderless mode
highlights.Border = { fg = colors.border }

-- ✅ Correct - adapts to border setting
if config.borders == "none" then
  highlights.Border = { fg = colors.bg, bg = colors.bg }
else
  highlights.Border = { fg = colors.border }
end
```

### 4. Hardcoding Colors

```lua
-- ❌ Wrong - hardcoded color won't adapt to colorscheme
highlights.Error = { fg = "#ff0000" }

-- ✅ Correct - use extracted color
highlights.Error = { fg = colors.red }
```

## Examples

See these files for real examples:
- `integrations/telescope.lua` - Border-aware, complex layout
- `integrations/cmp.lua` - Uses icon colors
- `integrations/noice.lua` - Simple highlights
- `integrations/lsp.lua` - Diagnostic patterns

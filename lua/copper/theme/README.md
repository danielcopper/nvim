# CopperVim Theme System

A modular, dynamic theming engine that manages colors, borders, icons, and UI styling across your Neovim configuration.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [User Commands](#user-commands)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Extending](#extending)

## Overview

The CopperVim theme system provides:

- **Centralized icon management** - Define icons once, use everywhere
- **Dynamic border switching** - Change border styles on-the-fly
- **Colorscheme-aware styling** - UI adapts to your active colorscheme
- **Hot-reload support** - Changes apply instantly without restart
- **Modular integrations** - Each plugin has its own styling module
- **Easy extensibility** - Add new colorschemes and plugins with minimal code

### What It Controls

- **Borders**: Window borders, float borders, completion borders
- **Icons**: LSP kinds, diagnostics, git, DAP, UI elements
- **Colors**: Extracted and standardized from any colorscheme
- **Layout**: Padding, spacing, and other UI preferences
- **Highlights**: Dynamic highlight groups for plugins

## Quick Start

The theme system is initialized automatically in `init.lua`. No setup required!

### Switch Border Styles

```vim
:ThemeBorders none      " No borders (NvChad-style)
:ThemeBorders single    " Single-line borders
:ThemeBorders rounded   " Rounded corners
:ThemeBorders double    " Double-line borders

:ThemeToggleBorders     " Cycle through all styles
```

### Switch Colorschemes

Just change your colorscheme normally - the theme system auto-reloads:

```vim
:colorscheme catppuccin
:colorscheme kanso
```

### View Current Theme

```vim
:ThemeInfo              " Show colorscheme, borders, colors
:ThemeReload            " Manually reload if needed
```

## User Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `:ThemeBorders` | `none\|single\|rounded\|double` | Set border style |
| `:ThemeToggleBorders` | - | Cycle through border styles |
| `:ThemeInfo` | - | Display current theme configuration |
| `:ThemeReload` | - | Manually reload theme system |

## Configuration

### Theme Config File

Main configuration: `lua/copper/theme/config.lua`

```lua
{
  colorscheme = "catppuccin",  -- Current colorscheme
  borders = "none",            -- Border style
  transparency = false,        -- Transparency support
  padding = { 0, 1 },         -- Floating window padding [vertical, horizontal]

  -- Which integrations are active
  integrations = {
    telescope = true,
    cmp = true,
    noice = true,
    lsp = true,
  },
}
```

### Programmatic API

```lua
local theme_config = require("copper.theme.config")

-- Change border style
theme_config.set("borders", "rounded")

-- Change padding
theme_config.set("padding", { 1, 2 })

-- Get current borders
local borders = theme_config.borders

-- Get border characters for plugins
local chars = theme_config.get_border_chars()
```

### Icon Access

```lua
local icons = require("copper.theme.icons")

-- LSP completion kinds
local func_icon = icons.kinds.Function     -- "󰊕"
local var_icon = icons.kinds.Variable      -- "󰀫"

-- Diagnostics
local error_icon = icons.diagnostics.Error -- "󰅚"
local warn_icon = icons.diagnostics.Warn   -- "󰀪"

-- Git
local add_icon = icons.git.Add             -- ""
local modify_icon = icons.git.Modify       -- ""

-- DAP
local breakpoint = icons.dap.Breakpoint    -- ""

-- UI
local folder_icon = icons.ui.Folder        -- "󰉋"
local search_icon = icons.ui.Search        -- ""
```

### Color Access

```lua
local theme = require("copper.theme")

-- Get standardized colors from current colorscheme
local colors = theme.get_colors()

-- Available color keys:
-- bg_darker, bg_dark, bg, bg_light, bg_lighter, bg_highlight
-- fg, fg_dim, fg_dimmer, fg_comment
-- border, border_highlight
-- blue, cyan, green, yellow, orange, red, purple, pink
-- none (= "NONE")

-- Example usage
vim.api.nvim_set_hl(0, "CustomHighlight", {
  fg = colors.blue,
  bg = colors.bg_dark,
})
```

## Architecture

### File Structure

```
lua/copper/theme/
├── README.md              # This file
├── EXTENDING.md           # Guide for adding colorschemes/integrations
├── config.lua             # Central configuration
├── icons.lua              # Icon definitions
├── colors.lua             # Color extraction logic
├── utils.lua              # Helper utilities
├── init.lua               # Main engine
└── integrations/          # Plugin-specific styling
    ├── telescope.lua
    ├── cmp.lua
    ├── noice.lua
    └── lsp.lua
```

### How It Works

```
1. Theme system initializes (init.lua loads copper.theme)
2. Config loaded from copper.theme.config
3. Colors extracted from active colorscheme
4. Each enabled integration loaded:
   - Integration receives: colors, config, icons
   - Returns: highlight group definitions
5. Highlights applied to Neovim
6. ColorScheme autocmd → auto-reload on colorscheme change
```

### Integration Flow

```lua
-- Example: telescope integration
function M.get(colors, config, icons)
  local highlights = {}

  if config.borders == "none" then
    -- Borderless mode: different backgrounds
    highlights.TelescopePromptBorder = {
      bg = colors.bg_light,
      fg = colors.bg_light
    }
  else
    -- Bordered mode: visible borders
    highlights.TelescopePromptBorder = {
      bg = colors.bg,
      fg = colors.border
    }
  end

  return highlights
end
```

### Border Styles

Each border style has:
1. **Config value**: `"none"`, `"single"`, `"rounded"`, `"double"`
2. **Border characters**: Used by plugins like Telescope
3. **Integration behavior**: Different highlight strategies

**Example: Telescope with different borders**

- `none`: Different backgrounds (prompt, results, preview), invisible borders
- `single`: Same background, visible single-line borders, colored titles
- `rounded`: Same as single but with rounded corners
- `double`: Same as single but with double-line borders

## Extending

See [EXTENDING.md](./EXTENDING.md) for detailed guides on:

- Adding new colorschemes
- Creating new plugin integrations
- Adding custom UI settings
- Advanced customization

## Examples

### Custom Border Style Keybinding

Add to `lua/config/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>tb", function()
  vim.cmd("ThemeToggleBorders")
end, { desc = "Toggle border style" })
```

### Conditional Styling Based on Mode

```lua
-- In an integration file
function M.get(colors, config, icons)
  local highlights = {}

  if config.borders == "none" and config.transparency then
    -- Special handling for transparent + borderless
    highlights.SomeGroup = { bg = "NONE", fg = colors.fg }
  else
    highlights.SomeGroup = { bg = colors.bg, fg = colors.fg }
  end

  return highlights
end
```

### Custom Integration

Create `lua/copper/theme/integrations/myplugin.lua`:

```lua
local M = {}

function M.get(colors, config, icons)
  return {
    MyPluginNormal = { bg = colors.bg, fg = colors.fg },
    MyPluginBorder = { fg = colors.border },
    MyPluginTitle = { fg = colors.blue, bold = true },
  }
end

return M
```

Enable in `config.lua`:

```lua
integrations = {
  telescope = true,
  cmp = true,
  noice = true,
  lsp = true,
  myplugin = true,  -- Add this
}
```

## Troubleshooting

### Theme Not Loading

```vim
:ThemeReload
```

### Colors Look Wrong

Check that your colorscheme is supported:

```vim
:ThemeInfo
```

If using a custom colorscheme, you may need to add an extraction function. See [EXTENDING.md](./EXTENDING.md).

### Icons Not Showing

Ensure you have a Nerd Font installed and configured in your terminal.

Check icon definitions:

```lua
:lua vim.print(require("copper.theme.icons").kinds)
```

### Borders Not Applying

Some plugins may need restart after changing borders. Try:

```vim
:ThemeReload
:q
:e  " Reopen file
```

Or fully restart Neovim.

## Performance

The theme system adds minimal overhead:
- Initial load: ~2-3ms
- Reload: ~1-2ms
- Per-integration: ~0.1-0.3ms

No disk caching is used (unlike Base46) for simplicity and debuggability.

## Related Files

Theme system is used by these plugin configs:
- `lua/plugins/telescope.lua` - Border characters
- `lua/plugins/completion.lua` - Borders and icons
- `lua/plugins/noice.lua` - Borders and padding
- `lua/plugins/lsp.lua` - Diagnostic icons and borders
- `lua/config/options.lua` - Global winborder setting

## Credits

Inspired by:
- [NvChad's Base46](https://github.com/NvChad/base46) - Theming architecture
- [Catppuccin](https://github.com/catppuccin/nvim) - Color palette system
- [LazyVim](https://github.com/LazyVim/LazyVim) - Plugin integration patterns

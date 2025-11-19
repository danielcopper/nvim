# Theme Configuration Refactor Plan

## Goal

Replace `nvim-harmony` plugin with a simple, explicit theme configuration module. Remove all abstraction layers and complexity while keeping the functionality.

## Current State

- Using `nvim-harmony` plugin (~1500+ lines)
- Auto-configuration via lazy.nvim specs system
- Complex preset/integration/extraction systems
- Hard to debug, lots of "magic"

## Target State

- Simple `lua/theme.lua` module (~50 lines)
- Explicit plugin configurations
- One central place to change theme settings
- Easy to understand and debug

---

## Step 1: Create Simple Theme Module

Create `/home/daniel/.config/nvim/lua/theme.lua`:

```lua
-- Simple theme configuration module
-- Single source of truth for all theme settings
local M = {}

-- ============================================================================
-- Theme Settings (Change these to switch theme)
-- ============================================================================

M.colorscheme = {
  name = "rose-pine",    -- "rose-pine" | "catppuccin" | "kanagawa" | etc.
  variant = "main",      -- colorscheme-specific: "main"/"moon"/"dawn" for rose-pine
}

M.borders = "none"       -- "none" | "rounded" | "single" | "double"

M.dim_inactive = true    -- Dim inactive windows

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Get border for plugins that use string
function M.get_border()
  return M.borders
end

-- Get border as empty table for "none" (some plugins need this)
function M.get_border_or_empty()
  return M.borders == "none" and {} or M.borders
end

-- Get borderchars for telescope (8-element array)
function M.get_telescope_borderchars()
  if M.borders == "none" then
    return { " ", " ", " ", " ", " ", " ", " ", " " }
  elseif M.borders == "rounded" then
    return { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  elseif M.borders == "single" then
    return { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
  else
    return { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  end
end

return M
```

---

## Step 2: Configure Colorscheme Plugin

Update your colorscheme plugin to load and configure based on theme module.

Example for Rose Pine (`lua/plugins/colorscheme.lua`):

```lua
local theme = require("theme")

return {
  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    enabled = theme.colorscheme.name == "rose-pine",
    config = function()
      require("rose-pine").setup({
        dim_inactive_windows = theme.dim_inactive,
        dark_variant = theme.colorscheme.variant or "main",
      })
      vim.cmd("colorscheme rose-pine-" .. (theme.colorscheme.variant or "main"))
    end,
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = theme.colorscheme.name == "kanagawa",
    config = function()
      require("kanagawa").setup({
        dimInactive = theme.dim_inactive,
        keywordStyle = { italic = false },
        theme = theme.colorscheme.variant or "wave",
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    enabled = theme.colorscheme.name == "catppuccin",
    config = function()
      require("catppuccin").setup({
        dim_inactive = { enabled = theme.dim_inactive },
      })
      vim.cmd("colorscheme catppuccin-" .. (theme.colorscheme.variant or "mocha"))
    end,
  },
}
```

---

## Step 3: Configure Neovim Built-ins

Add to your `init.lua` or create `lua/config/builtin.lua`:

```lua
local theme = require("theme")

-- ============================================================================
-- Diagnostics
-- ============================================================================

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "●",
      [vim.diagnostic.severity.INFO] = "●",
      [vim.diagnostic.severity.HINT] = "●",
    },
  },
  float = {
    border = theme.get_border_or_empty(),
  },
  severity_sort = true,
})

-- ============================================================================
-- LSP Handlers
-- ============================================================================

local border = theme.get_border_or_empty()

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = border }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = border }
)

-- Override vim.ui.select for code actions (if not using noice)
local original_ui_select = vim.ui.select
vim.ui.select = function(items, opts, on_choice)
  opts = opts or {}
  if not opts.border then
    opts.border = border
  end
  original_ui_select(items, opts, on_choice)
end

-- ============================================================================
-- Fillchars (window separators)
-- ============================================================================

if theme.borders == "none" then
  vim.opt.fillchars = {
    vert = " ",
    vertleft = " ",
    vertright = " ",
    verthoriz = " ",
    horiz = " ",
    horizup = " ",
    horizdown = " ",
  }
end

-- ============================================================================
-- Listchars (whitespace visualization)
-- ============================================================================

vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
```

---

## Step 4: Configure Plugins

Update each plugin to use the theme module directly.

### Telescope

`lua/plugins/telescope.lua`:

```lua
local theme = require("theme")

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      borderchars = theme.get_telescope_borderchars(),
      prompt_prefix = "🔍  ",
      selection_caret = " ",
      entry_prefix = " ",
    },
  },
}
```

### Noice

`lua/plugins/noice.lua`:

```lua
local theme = require("theme")

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = { enabled = true },
      signature = { enabled = true },
      progress = { enabled = false },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = theme.borders ~= "none",
    },
    views = {
      cmdline_popup = {
        border = {
          style = theme.borders,
          padding = theme.borders == "none" and { 1, 1 } or { 0, 1 },
        },
      },
      popupmenu = {
        border = { style = theme.borders },
      },
      popup = {
        border = { style = theme.borders },
      },
      split = {
        border = theme.borders,
      },
      vsplit = {
        border = theme.borders,
      },
      confirm = {
        border = { style = theme.borders },
      },
      hover = {
        border = { style = theme.borders },
      },
      mini = {
        border = { style = theme.borders },
      },
    },
    routes = {
      {
        filter = { event = "notify" },
        view = "notify",
      },
    },
  },
}
```

### Mason

`lua/plugins/mason.lua`:

```lua
local theme = require("theme")

return {
  "williamboman/mason.nvim",
  opts = {
    ui = {
      border = theme.borders,
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
```

### nvim-cmp

`lua/plugins/cmp.lua`:

```lua
local theme = require("theme")

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- ... your cmp sources
  },
  opts = function()
    local cmp = require("cmp")

    return {
      window = {
        completion = cmp.config.window.bordered({
          border = theme.borders,
        }),
        documentation = cmp.config.window.bordered({
          border = theme.borders,
        }),
      },
      -- ... rest of cmp config
    }
  end,
}
```

### Lualine

`lua/plugins/lualine.lua`:

```lua
local theme = require("theme")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename" },
      lualine_c = {
        {
          "diff",
          colored = true,
          symbols = { added = " ", modified = " ", removed = " " },
        },
        { "branch", icon = "" },
      },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
        },
      },
      lualine_y = { "encoding", "filetype" },
      lualine_z = { "progress", "location" },
    },
  },
}
```

### Which-key

`lua/plugins/which-key.lua`:

```lua
local theme = require("theme")

return {
  "folke/which-key.nvim",
  opts = {
    window = {
      border = theme.borders,
    },
  },
}
```

### Trouble

`lua/plugins/trouble.lua`:

```lua
local theme = require("theme")

return {
  "folke/trouble.nvim",
  opts = {
    -- Trouble uses its own icon system, just works
  },
}
```

### Neo-tree

`lua/plugins/neo-tree.lua`:

```lua
local theme = require("theme")

return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    popup_border_style = theme.borders,
    -- ... rest of neo-tree config
  },
}
```

### Gitsigns

`lua/plugins/gitsigns.lua`:

```lua
local theme = require("theme")

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
  },
}
```

### nvim-notify

`lua/plugins/notify.lua`:

```lua
local theme = require("theme")

return {
  "rcarriga/nvim-notify",
  opts = {
    border = theme.borders,
    stages = "fade_in_slide_out",
    render = "compact",
  },
}
```

---

## Step 5: Remove nvim-harmony

1. Remove harmony from your plugin specs:
   - Delete `lua/plugins/harmony.lua` (or wherever you have it)
   - Remove `{ import = "harmony.specs" }` from lazy.nvim setup

2. Remove harmony dependency from other plugins:
   - Remove `dependencies = { "harmony" }` from plugin specs

3. Clean up:
   ```bash
   # Remove lazy.nvim cache
   rm -rf ~/.local/share/nvim/lazy/nvim-harmony

   # Restart Neovim
   nvim
   ```

---

## Step 6: Test Everything

After implementation, test:

1. **Colorscheme loading**: Restart nvim, check if colorscheme loads correctly
2. **Border consistency**: Check all floating windows (telescope, LSP hover, cmp, etc.)
3. **Diagnostics**: Check signs in gutter
4. **Lualine**: Check statusline components
5. **Code actions**: Trigger code action, check border
6. **Switching theme**: Change `theme.lua`, restart, verify everything updates

---

## Expected Results

### Before (nvim-harmony):
- ~1500+ lines of plugin code
- Auto-configuration "magic"
- Hard to debug
- Complex abstraction layers
- Specs/presets/integrations systems

### After (simple theme module):
- ~50 lines theme module
- ~20-50 lines per plugin config
- Total: ~300-500 lines (explicit, readable)
- Easy to debug (just read the plugin file)
- No magic, no abstractions
- Full visibility and control

---

## Benefits

1. **Simplicity**: One small module instead of a complex plugin
2. **Visibility**: See exactly what's configured in each plugin file
3. **Debugging**: Easy to trace - just read the plugin config
4. **Performance**: Same performance (module caching)
5. **Maintainability**: No complex systems to maintain
6. **Flexibility**: Easy to customize per-plugin without fighting abstraction

---

## Future: Switching Colorschemes

To switch colorschemes, just edit `lua/theme.lua`:

```lua
-- Switch from rose-pine to catppuccin
M.colorscheme = {
  name = "catppuccin",  -- Changed
  variant = "mocha",    -- Changed
}

M.borders = "rounded"   -- Optional: change border style too
```

Restart Neovim. Everything updates automatically.

---

## Migration Checklist

- [ ] Create `lua/theme.lua` module
- [ ] Update colorscheme plugin with conditional loading
- [ ] Configure built-ins (diagnostics, LSP, fillchars)
- [ ] Update telescope config
- [ ] Update noice config
- [ ] Update mason config
- [ ] Update cmp config
- [ ] Update lualine config
- [ ] Update which-key config
- [ ] Update trouble config
- [ ] Update neo-tree config
- [ ] Update gitsigns config
- [ ] Update notify config
- [ ] Remove nvim-harmony from plugins
- [ ] Remove harmony specs import from lazy.nvim
- [ ] Test all functionality
- [ ] Verify colorscheme switching works

---

## Notes

- Keep the nvim-harmony repo for reference, don't delete it yet
- You can implement one plugin at a time (incremental migration)
- The `require("theme")` call is cached by Neovim, so no performance penalty
- If you want to share your config, `lua/theme.lua` is clear and easy for others to understand

---

## Final Thoughts

This refactor trades "automatic configuration" for "explicit configuration." For a single-user setup where you control everything, explicit is better:

- You see what's configured
- You understand how it works
- You can debug easily
- You can customize freely
- No surprises, no magic

The complexity of nvim-harmony made sense for distributing to many users who don't want to configure things manually. For your personal config, simpler is better.

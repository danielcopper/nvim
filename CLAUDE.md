# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

CopperVim is a personal Neovim configuration designed to work on both Linux and Windows. It uses the Lazy.nvim plugin manager with a modular structure organized under the `lua/copper/` namespace.

## Architecture

### Configuration Structure

The configuration follows a modular architecture with clear separation of concerns:

- **`init.lua`**: Entry point that loads core configuration modules in sequence
- **`lua/copper/config/`**: Core Neovim settings
  - `options.lua`: All vim options, globals, and custom `vim.copper_config` table
  - `keymaps.lua`: General keybindings (non-plugin specific)
  - `autocmds.lua`: Autocommands for file handling, highlighting, and behavior
  - `icons.lua`: Centralized icon definitions used across plugins
  - `filetype.lua`: Custom filetype detection
- **`lua/copper/lazy.lua`**: Lazy.nvim plugin manager setup and configuration
- **`lua/copper/plugins/`**: Plugin configurations organized by category:
  - `coding/`: Code editing tools (treesitter, completion, formatting, terminal, etc.)
  - `debugging/`: DAP debugger configuration
  - `editor/`: Editor enhancement plugins (telescope, neo-tree, which-key, etc.)
  - `lsp/`: LSP configurations and related tools
  - `ui/`: UI enhancements (statusline, notifications, colorschemes, etc.)
  - `vscode.lua`: VSCode Neovim integration settings

### Plugin Loading Strategy

Lazy.nvim conditionally loads plugins based on the environment:
- Most plugins are disabled when running inside VSCode (`cond = not vim.g.vscode`)
- Each plugin category is imported from its respective directory
- Plugins use lazy-loading with `event`, `cmd`, or `keys` triggers for performance

### Global Configuration Table

The `vim.copper_config` table (defined in `lua/copper/config/options.lua`) stores custom settings:
- `borders`: UI border style (default: "none")
- `colorscheme`: Active colorscheme (default: "catppuccin")
- `transparency`: Transparency setting (default: false)

This table is referenced throughout plugin configurations for consistent theming.

### LSP Architecture

LSP setup (`lua/copper/plugins/lsp/lspconfig.lua`) uses Mason for automatic server installation:
- Mason and mason-lspconfig handle LSP server lifecycle
- Custom handlers configure UI elements (borders, floating windows)
- Capabilities are enhanced with nvim-cmp and folding support
- Server-specific configurations use mason-lspconfig's `setup_handlers` pattern
- LSP keybindings are attached via `LspAttach` autocommand (not in `on_attach` function)
- Supports multiple languages: Angular, Bash, CSS, Docker, HTML, JSON, Lua, Markdown, PowerShell, TypeScript, YAML
- C# support via Roslyn LSP (OmniSharp configuration is commented out)

## Common Commands

### Formatting

Code formatting is primarily handled through LSP:
- `<leader>cf`: Quick format current buffer (LSP-based, async)
- `<leader>cF`: Format with conform.nvim (currently disabled)

To format Lua code manually:
```bash
stylua .
```

StyLua configuration is in `stylua.toml`:
- 2-space indentation
- 120 column width
- Requires sorting enabled

### LSP Management

```vim
:LspInfo          " Show LSP client information
:LspRestart       " Restart LSP servers (also <leader>rs)
:Mason            " Open Mason UI for LSP server management
```

### Plugin Management

```vim
:Lazy             " Open Lazy.nvim UI
:Lazy sync        " Update and install plugins
:Lazy clean       " Remove unused plugins
:Lazy profile     " Profile startup time
```

### Treesitter

```vim
:TSUpdate         " Update all parsers
:TSInstall <lang> " Install specific parser
:TSUpdateSync     " Synchronous update
```

### DAP (Debugging)

- DAP configurations are loaded from `.vscode/launch.json` files
- `<leader>du`: Toggle DAP UI
- `<leader>de`: Evaluate expression
- DAP setup includes virtual text and UI integration

## Development Notes

### Keybinding Conventions

- Leader key: `<Space>`
- Local leader: `\`
- LSP bindings are set on `LspAttach` autocommand (see `lspconfig.lua:134-206`)
- Plugin-specific keybindings are defined in their respective plugin config files
- Common prefixes:
  - `<leader>c`: Code actions (format, actions)
  - `<leader>d`: Debug/diagnostics
  - `<leader>v`: View/diagnostics
  - `g*`: Go to (definition, references, etc.)
  - `]`/`[`: Next/previous (diagnostics, etc.)

### Adding New LSP Servers

1. Add server name to `ensure_installed` in `lspconfig.lua:221-244`
2. If custom configuration is needed, add a handler in `mason_lspconfig.setup_handlers` (line 247+)
3. Default handler applies `capabilities` and `handlers` to all servers
4. Server-specific settings go in the handler's `settings` table

### Plugin Configuration Pattern

Each plugin file in `lua/copper/plugins/` should return a table (or array of tables) with:
```lua
return {
  "author/plugin-name",
  event = { "BufReadPre", "BufNewFile" },  -- or cmd, keys, etc.
  dependencies = { ... },
  opts = { ... },  -- passed to setup()
  config = function(_, opts)
    -- Custom setup logic
  end,
}
```

### Icons

Icons are centralized in `lua/copper/config/icons.lua`. Reference them with:
```lua
local icons = require("copper.config.icons")
-- icons.diagnostics, icons.git, icons.ui, icons.dap, etc.
```

### Windows Compatibility

- Configuration aims for cross-platform compatibility
- Known issue: Some treesitter parsers (html, yaml) may fail on Windows - solution involves deleting `libstdc++-6.dll` from Neovim install location
- PowerShell LSP is configured with custom bundle path for Windows
- MinGW may be required for C compilation on Windows

### File Type Specific Settings

- Spell checking and word wrap auto-enable for: gitcommit, markdown, tex
- Last cursor position is remembered across sessions
- External programs open for: png, jpg, gif, pdf, xls, ppt, doc, rtf files

### Session Management

Session options include: buffers, curdir, tabpages, winsize, help, globals, skiprtp, folds

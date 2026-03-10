# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

CopperVim is a personal Neovim configuration designed to work on both Linux and Windows. It uses Lazy.nvim for plugin management with a flat plugin structure.

## Architecture

### Configuration Structure

- **`init.lua`**: Entry point — loads `.env`, bootstraps Lazy.nvim, loads config modules
- **`lua/config/`**: Core Neovim settings
  - `options.lua`: Vim options, globals, leader key setup
  - `keymaps.lua`: General keybindings (non-plugin specific)
  - `autocmds.lua`: Autocommands for file handling, highlighting, and behavior
  - `vscode.lua`: VSCode Neovim integration settings
  - `colorscheme.lua`: Active colorscheme name and variant
  - `icons.lua`: Centralized icon definitions used across plugins
- **`lua/plugins/`**: Plugin configurations (one file per plugin, flat structure)
  - `colorschemes/`: One file per colorscheme — each handles its own setup and injects visual overrides into other plugins via Lazy.nvim spec merging
  - `lsp/`: LSP-specific configs (`init.lua`, `servers.lua`, `keymaps.lua`)
- **`ftplugin/`**: Filetype-specific settings (java, json, lua, solution, xml)

### Plugin Loading Strategy

- Lazy.nvim conditionally loads plugins via a VSCode whitelist in `init.lua`
- Most plugins use lazy-loading with `event`, `cmd`, or `keys` triggers
- Only whitelisted plugins load in VSCode (treesitter, surround, autopairs, which-key)

### Theme System

Active colorscheme is configured in `lua/config/colorscheme.lua` (name + variant).

Each colorscheme has its own file in `lua/plugins/colorschemes/` (e.g., `catppuccin.lua`, `rose-pine.lua`). These files are self-contained — they handle colorscheme setup, custom highlight overrides, and inject visual config (borders, backgrounds, borderchars) into other plugins via Lazy.nvim spec merging. Each file early-returns `{}` if it's not the active colorscheme.

### LSP Architecture

- `lua/plugins/lsp/init.lua`: Diagnostic config, capabilities setup
- `lua/plugins/lsp/servers.lua`: Per-server configurations using native `vim.lsp.config()` and `vim.lsp.enable()` (Neovim 0.11 API)
- `lua/plugins/lsp/keymaps.lua`: LSP keybindings attached via `LspAttach` autocommand
- `lua/plugins/mason.lua` + `mason-packages.lua`: Mason setup and tool installation list

Supported languages: Angular, Bash, C#, CSS, Docker, HTML, JSON, Lua, Markdown, PowerShell, Python, TypeScript, XML, YAML (including Azure Pipelines)

### Adding New LSP Servers

1. Add the mason package name to `mason-packages.lua`
2. Add server config to `lsp/servers.lua` using `vim.lsp.config()` pattern
3. Add the server name to the `vim.lsp.enable()` list in `lsp/servers.lua`

## Common Commands

### Formatting

- `<leader>cf`: Format with conform.nvim (LSP fallback)
- Lua: `stylua .` (config in `stylua.toml`: 2-space indent, 120 columns)

### LSP Management

```vim
:LspInfo          " Show LSP client information
:LspRestart       " Restart LSP servers
:Mason            " Open Mason UI
```

### Plugin Management

```vim
:Lazy             " Open Lazy.nvim UI
:Lazy sync        " Update and install plugins
:Lazy profile     " Profile startup time
```

## Keybinding Conventions

- Leader key: `<Space>`, Local leader: `\`
- `<leader>c`: Code actions (format, actions)
- `<leader>d`: Debug/diagnostics
- `<leader>v`: View/diagnostics
- `g*`: Go to (definition, references, etc.)
- `]`/`[`: Next/previous (diagnostics, buffers, etc.)

### Icons

Icons are centralized in `lua/config/icons.lua`:
```lua
local icons = require("config.icons")
-- icons.diagnostics, icons.git, icons.ui, icons.dap, icons.lsp
```

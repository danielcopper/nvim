# CLAUDE.md

Minimal working rules for Claude Code (and similar AI assistants) in this repo.
For architecture, plugin overview, and setup, see [README.md](README.md).

## Rules

### Adding a new LSP server

1. Add the Mason package name to `lua/plugins/mason-packages.lua`.
2. (Optional) Create `lsp/<server_name>.lua` returning `{ cmd, filetypes, root_markers, settings }` if custom settings are needed.
3. Add the server name to the `vim.lsp.enable({...})` list in `lua/config/lsp.lua`.

### Keybinding conventions

- Leader: `<Space>`, Local leader: `\`
- `<leader>c*` — code actions (format, rename)
- `<leader>d*` — debug (DAP)
- `<leader>x*` — diagnostics / quickfix (trouble)
- `<leader>g*` — git
- `g*` — go to (definition, references, etc.)
- `]` / `[` — next / previous (buffers, diagnostics, hunks)

### Formatting

- `<leader>cf` — format the current buffer (conform.nvim, LSP fallback)
- Lua files are formatted with `stylua` (defaults; no project-level config)

## Common commands

```vim
:LspInfo          " Show LSP client information
:LspRestart       " Restart LSP servers
:Mason            " Open Mason UI
:Lazy             " Open Lazy.nvim UI
:Lazy sync        " Update and install plugins
:Lazy profile     " Profile startup time
```

## Icons

Centralized in `lua/config/icons.lua`:

```lua
local icons = require("config.icons")
-- icons.diagnostics, icons.git, icons.ui, icons.dap, icons.lsp
```

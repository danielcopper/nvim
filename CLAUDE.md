# CLAUDE.md

Minimal working rules for Claude Code (and similar AI assistants) in this repo.
For architecture, plugin overview, and setup, see [README.md](README.md).

## Rules

### Adding a new plugin

1. Create `plugin/<name>.lua`.
2. At the top: `vim.pack.add({ "https://github.com/<owner>/<repo>" })`.
3. Below: `require("<name>").setup({...})` if custom config is needed.
4. If the plugin has dependencies, list them **before** the plugin URL in the `vim.pack.add` array — array order = `packadd` order = `runtimepath` order.
5. Plugins that depend on each other (e.g. mason + mason-tool-installer) belong in the **same file** to guarantee setup order.

### Adding a new LSP server

1. Add the Mason package name to `plugin/mason.lua` (ensure_installed list).
2. (Optional) Create `lsp/<server_name>.lua` returning `{ cmd, filetypes, root_markers, settings }` if custom settings are needed.
3. Add the server name to the `vim.lsp.enable({...})` list in `plugin/lsp.lua`.

### Keybinding conventions

- Leader: `<Space>`, Local leader: `\`
- `<leader>c*` — code actions (format, rename)
- `<leader>d*` — debug (DAP)
- `<leader>n*` — neovim (pack update, status)
- `<leader>x*` — diagnostics / quickfix (trouble)
- `<leader>g*` — git
- `g*` — go to (definition, references, etc.)
- `]` / `[` — next / previous (buffers, diagnostics, hunks)

### Formatting

- `<leader>cf` — format the current buffer (conform.nvim, LSP fallback)
- Lua files are formatted with `stylua` (defaults; no project-level config)

## Common commands

```vim
:LspInfo          " Show LSP health (alias for :checkhealth vim.lsp)
:lsp restart      " Restart LSP servers (native Nvim 0.12)
:Mason            " Open Mason UI
:lua vim.pack.update()   " Update all plugins (or <leader>nu)
:lua vim.pack.get()      " List installed plugins (or <leader>ns)
```

## Icons

Centralized in `lua/icons.lua`:

```lua
local icons = require("icons")
-- icons.diagnostics, icons.git, icons.ui, icons.dap, icons.lsp
```

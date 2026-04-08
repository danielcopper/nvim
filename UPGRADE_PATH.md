# Upgrade Path

Roadmap for migrating CopperVim to newer Neovim native APIs.

## Done on 0.11

### Drop nvim-lspconfig + mason-lspconfig

- Removed `neovim/nvim-lspconfig` and `williamboman/mason-lspconfig.nvim`
- Server configs live in `lsp/*.lua` (native 0.11 auto-discovery)
- Global capabilities set via `vim.lsp.config('*', { ... })`
- Servers enabled via `vim.lsp.enable()` in `lua/config/lsp.lua`
- Mason stays for binary installation (`mason.nvim` + `mason-tool-installer.nvim`)

## Done on 0.12

### Replace fidget.nvim with native progress

- `LspProgress` autocmd creates progress messages via `nvim_echo` (kind=progress)
- Disabled `progress:c` in `messagesopt` (no cmdline noise)
- `vim.ui.progress_status()` shown as lualine component (auto-hides when idle)
- Removed `lua/plugins/fidget.lua`
- Note: ui2 is NOT enabled — it conflicts with noice.nvim's cmdline handling

## Still open

### Evaluate nvim-treesitter main branch

The `main` branch is a complete rewrite (March 2026, repo archived April 2026).
Breaking changes vs `master`:

| Feature | master | main (0.12+) |
|---|---|---|
| `ensure_installed` | list in setup | removed — manual install API |
| `highlight = { enable = true }` | auto-enables | removed — use `vim.treesitter.start()` |
| `indent = { enable = true }` | auto-enables | removed — manual autocmd |
| `incremental_selection` | built-in | removed |
| `textobjects` | built-in module | separate plugin (`nvim-treesitter-textobjects` main branch) |

Migration requires rewriting the entire treesitter config. Evaluate when:
1. You're on Neovim 0.12+
2. `master` branch stops receiving parser updates
3. You're willing to replace textobjects/incremental-selection setup

### Consider dropping Mason entirely (optional, low priority)

If all LSP servers, formatters, and linters are available via system package manager
or nix, Mason becomes redundant. This is a convenience vs control trade-off — only
worth it if you standardize tooling across machines another way.

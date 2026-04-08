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

### Migrate nvim-treesitter to main branch

- Switched both `nvim-treesitter` and `nvim-treesitter-textobjects` to `main` branch
- Highlight/indent via `FileType` autocmd (`vim.treesitter.start()`, `indentexpr`)
- Parser install via `require('nvim-treesitter').install()`
- Textobjects: keymaps via `vim.keymap.set` with module functions (new API)
- Incremental selection: native 0.12 (`an`/`in`/`]n`/`[n`), remapped `<C-space>`/`<bs>`
- Multi-language injection works automatically
- ufo kept as-is (uses treesitter as fold provider, complementary not redundant)

### Consider dropping Mason entirely (optional, low priority)

If all LSP servers, formatters, and linters are available via system package manager
or nix, Mason becomes redundant. This is a convenience vs control trade-off — only
worth it if you standardize tooling across machines another way.

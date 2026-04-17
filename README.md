```
  ╔═╗┌─┐┌─┐┌─┐┌─┐┬─┐╦  ╦┬┌┬┐
  ║  │ │├─┘├─┘├┤ ├┬┘╚╗╔╝││││
  ╚═╝└─┘┴  ┴  └─┘┴└─ ╚╝ ┴┴ ┴
  ~~~~~~~~~~~~~~~~~~~~~~~~~~
  hand-rolled · neovim 0.12
```

Personal Neovim configuration for Linux + Windows (WSL). Built on Neovim 0.12 with [Lazy.nvim](https://github.com/folke/lazy.nvim) and native LSP.

## Requirements

- Neovim 0.12+ (`nvim --version`)
- `git`, `make`, `cc` (or MSVC on Windows)
- `tree-sitter` CLI (parser compilation)
- `ripgrep`, `fd` (telescope)
- Language runtimes (install as needed): `node`, `python3`, `java`, `dotnet`

## Installation

```bash
git clone <repo-url> ~/.config/nvim
cp ~/.config/nvim/.env.example ~/.config/nvim/.env  # fill in your tokens
nvim                                                # bootstraps Lazy + Mason
```

First launch runs `mason-tool-installer` with a 3s delay, installing ~25 packages (LSP servers, formatters, linters, DAP adapters). Run `:checkhealth` afterwards to flag any missing externals.

## Architecture

```
init.lua                      .env loader, Lazy bootstrap, module loads
lua/config/                   core settings (options, keymaps, autocmds, LSP, icons)
lua/plugins/                  one file per plugin (flat, ~47 plugins)
lua/plugins/colorschemes/     one file per theme, highlights merged into other plugins
lsp/<server>.lua              per-server configs (native vim.lsp.enable auto-discovery)
ftplugin/<ft>.lua             filetype-specific settings
lua/worktree.lua              git worktree switcher (<leader>gw)
```

Inside VSCode-Neovim, only a small whitelist loads (treesitter, surround, autopairs, which-key). See `init.lua` for the list.

See [`CLAUDE.md`](CLAUDE.md) for repo-specific rules (adding LSP servers, code conventions).

## Plugin highlights

| Area | Plugin |
|---|---|
| Completion | blink.cmp |
| LSP | native `vim.lsp.config` + Mason |
| Explorer | neo-tree |
| Finder | telescope |
| Git | gitsigns · diffview · octo (GitHub) · adopure (Azure DevOps) |
| Statusline / buffers | lualine · bufferline |
| Syntax / folds | nvim-treesitter (main branch) · nvim-ufo |
| Format / lint | conform.nvim · nvim-lint |
| Debug | nvim-dap |
| AI | claude-code.nvim |
| SQL (T-SQL) | mssql.nvim · sqlfluff |
| Notebooks | molten-nvim |

## Worktree workflow

Branches live as git worktrees under `.worktrees/` (globally gitignored):

```bash
git worktree add .worktrees/feature/oauth -b feature/oauth main
```

- Types: `feature/`, `fix/`, `refactor/`, `chore/`, `docs/`
- Switch inside Neovim: `<leader>gw` (picker via `lua/worktree.lua`)
- Remove: `git worktree remove .worktrees/feature/oauth && git branch -d feature/oauth`

## Keybinding conventions

| Prefix | Purpose |
|---|---|
| `<leader>c*` | code actions (format, rename) |
| `<leader>d*` | debug (DAP) |
| `<leader>x*` | diagnostics / quickfix (trouble) |
| `<leader>g*` | git (diffview, worktree, lazygit) |
| `<leader>h*` | git hunks (gitsigns) |
| `<leader>f*` | find / file (telescope) |
| `<leader>t*` | tools (explorer, tips, mason) |
| `<leader>a*` | AI / claude |
| `g*` | go to (definition, references, implementation) |
| `]` / `[` | next / previous (buffers, diagnostics, hunks) |

Press `<leader>?` for buffer-local keymap overview (which-key).

## Customizing

- Colorscheme + variant: `lua/plugins/colorschemes/init.lua`
- Neovim options: `lua/config/options.lua`
- Plugin config: one file in `lua/plugins/<name>.lua`
- Filetype-specific: `ftplugin/<ft>.lua`
- New LSP server: add to `mason-packages.lua`, optionally `lsp/<name>.lua`, then `vim.lsp.enable({...})` in `lua/config/lsp.lua`

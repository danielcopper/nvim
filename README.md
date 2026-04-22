![CopperVim](docs/banner.png)

Personal Neovim configuration for Linux + Windows (WSL). Built on Neovim 0.12 with [vim.pack](https://neovim.io/doc/user/pack/) (native plugin manager) and native LSP.

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
nvim                                                # bootstraps vim.pack + Mason
```

First launch clones all plugins via `vim.pack.add()`, then `mason-tool-installer` installs ~25 packages (LSP servers, formatters, linters, DAP adapters) with a 3s delay. Run `:checkhealth` afterwards to flag any missing externals.

## Architecture

```
init.lua                      .env loader, core module loads (options, keymaps, autocmds)
lua/config/                   core settings (options, keymaps, autocmds)
lua/                          shared modules (icons, ui preferences, lsp_state)
plugin/                       one file per plugin setup (auto-sourced by Nvim after init.lua)
lsp/<server>.lua              per-server configs (native vim.lsp.enable auto-discovery)
ftplugin/<ft>.lua             filetype-specific settings
lua/worktree.lua              git worktree switcher (<leader>gw)
```

## Plugin management

All plugins are managed by `vim.pack` (Nvim 0.12+ built-in). Each plugin is self-contained in `plugin/<name>.lua` — the file calls `vim.pack.add({...})` to install and then sets up the plugin. Nvim auto-sources all `plugin/*.lua` files alphabetically after `init.lua`.

**Dependency rule:** `vim.pack.add` array order determines load order. Dependencies must come **before** the plugin that needs them in the array. This ensures the dependency is on `runtimepath` before `require()` is called. Plugins that depend on each other belong in the **same file**.

| Command                       | Description                               |
| ----------------------------- | ----------------------------------------- |
| `<leader>nu`                  | Update all plugins (`vim.pack.update()`)  |
| `<leader>ns`                  | Show installed plugins (`vim.pack.get()`) |
| `:lua vim.pack.update()`      | Interactive update with diff confirmation |
| `:lua vim.pack.del({"name"})` | Remove a plugin                           |

Lockfile: `nvim-pack-lock.json` (auto-managed, check into version control).

## Plugin highlights

| Area                 | Plugin                                                       |
| -------------------- | ------------------------------------------------------------ |
| Completion           | blink.cmp + LuaSnip                                          |
| LSP                  | native `vim.lsp.config` + Mason                              |
| Explorer             | neo-tree                                                     |
| Finder               | telescope + fzf-native                                       |
| Git                  | gitsigns · diffview · octo (GitHub) · adopure (Azure DevOps) |
| Statusline / buffers | lualine · bufferline                                         |
| Syntax / folds       | nvim-treesitter (main branch) · nvim-ufo                     |
| Format / lint        | conform.nvim · nvim-lint · sonarlint                         |
| Debug                | nvim-dap + dap-ui                                            |
| AI                   | claude-code.nvim                                             |
| SQL (T-SQL)          | mssql.nvim · sqlfluff                                        |
| Notebooks            | molten-nvim                                                  |
| UI                   | noice · nvim-notify · catppuccin                             |

## Worktree workflow

Branches live as git worktrees under `.worktrees/`:

```bash
git worktree add .worktrees/feature/oauth -b feature/oauth main
```

- Types: `feature/`, `fix/`, `refactor/`, `chore/`, `docs/`
- Switch inside Neovim: `<leader>gw` (picker via `lua/worktree.lua`)
- Remove: `git worktree remove .worktrees/feature/oauth && git branch -d feature/oauth`

## Keybinding conventions

| Prefix       | Purpose                                        |
| ------------ | ---------------------------------------------- |
| `<leader>c*` | code actions (format, rename)                  |
| `<leader>d*` | debug (DAP)                                    |
| `<leader>x*` | diagnostics / quickfix (trouble)               |
| `<leader>g*` | git (diffview, worktree, lazygit)              |
| `<leader>h*` | git hunks (gitsigns)                           |
| `<leader>f*` | find / file (telescope)                        |
| `<leader>n*` | neovim (pack update, status)                   |
| `<leader>t*` | tools (explorer, tips, mason)                  |
| `<leader>a*` | AI / claude                                    |
| `g*`         | go to (definition, references, implementation) |
| `]` / `[`    | next / previous (buffers, diagnostics, hunks)  |

Press `<leader>?` for buffer-local keymap overview (which-key).

## Customizing

- Colorscheme: `plugin/catppuccin.lua`
- UI preferences (borders): `lua/ui.lua`
- Neovim options: `lua/config/options.lua`
- Plugin config: `plugin/<name>.lua`
- Filetype-specific: `ftplugin/<ft>.lua`
- New LSP server: add to `plugin/mason-packages.lua`, optionally `lsp/<name>.lua`, then add to `vim.lsp.enable({...})` in `plugin/lsp.lua`
- New plugin: add URL to `vim.pack.add({...})` in `init.lua`, optionally create `plugin/<name>.lua` for setup

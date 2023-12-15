# CopperVim

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

<!--toc:start-->

- [CopperVim](#coppervim)
  - [Install](#install)
    - [Linux](#linux)
    - [Windows](#windows)
    - [Dependencies and Helpful Tools](#dependencies-and-helpful-tools)
      - [MinGW (for windows)](#mingw-for-windows)
    - [Troubleshooting](#troubleshooting)
  - [LSP](#lsp)
    - [Angular](#angular)
  - [TODO](#todo)
  - [Plugins to consider](#plugins-to-consider)
  <!--toc:end-->

These are my config files for Neovim. They aim to work on both Linux and
Windows.

## Install

Clone this repo into the nvim standard path **Linux**: ~/.config/nvim
**Windows**: `OS:/Users/<your-user-name/AppData/Local/nvim`

### Linux

Use your favorite package manager.

### Windows

For Windows open pwsh and execute:

```pwsh
winget install Neovim.Neovim
```

This should also add neovim to the Path environment, but make sure it is added.
For convenience it could be helpful to have a separate environment variable for
Neovim that points to the nvim folder to where the Repo was cloned.

Chocolatey might be helpful to install MingW and other missing tools that throw
errors in :checkhealth.

### Dependencies and Helpful Tools

#### MinGW (for windows)

MinGW is a compiler collection that includes the needed c compiler for windows.
There are other options, but I had the most success with this one.

To install MinGW you need chocolatey currently, execute: `choco install mingw`

### Troubleshooting

On windows with some language parser errors in treesitter can occur, for example
html and yaml. Check [this][treesitter-help-link] for a solution.

What you have to do is to delete the libstdc++-6.dll that you can find in the
install location from neovim. After that remove the nvim-data folder, restart
the pc and let nvim initialize again.

## LSP

### Angular

For Angular Language Service to work you either have to be sure to install
typescript and angular/language-service as a dev dependency on the project or
TODO: find a solution for the LSP setup to set the correct parameters
automatically (LSP Zero seems to do that correctly).

## TODO

- Fix recording keys not working (it works just doesn't prompt that its
  recording)
- configure DAP for c# and typescript (partly finished)
- Adjust Readme to Linux
- autocomand to replace :q to bufdel or checkout mini bufremove
- Cleanup and simplify after everything works as it should
- Define borderstyle for hover etc globally
- TestRunner for dotnet (Neotest?)
- Auto use compiler when starting dap
- adjust tab key to better work together with cmp
- update which key (general modes "+code" and so on)

## Plugins to consider

- [dap configs](https://github.com/ldelossa/nvim-dap-projects)
- [Neodev](https://github.com/folke/neodev.nvim)
- [Pick lsp formatter](https://github.com/fmbarina/pick-lsp-formatter.nvim)

[treesitter-help-link]:
  https://github.com/nvim-treesitter/nvim-treesitter/issues/3587#issuecomment-1306608973

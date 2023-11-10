# CopperVim

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

<!--toc:start-->
- [CopperVim](#coppervim)
  - [Install](#install)
    - [Windows](#windows)
    - [Dependencies and Helpful Tools](#dependencies-and-helpful-tools)
      - [MinGW (for windows)](#mingw-for-windows)
      - [Lazygit](#lazygit)
    - [Troubleshooting](#troubleshooting)
  - [LSP](#lsp)
    - [Angular](#angular)
  - [Debugging](#debugging)
    - [dotNET](#dotnet)
  - [TODO](#todo)
  - [Plugins to consider](#plugins-to-consider)
<!--toc:end-->

These are my config files for Neovim.

## Install

Clone this repo and move the contents to ```OS:/Users/<your-user-name/AppData/Local/nvim```

### Windows

For Windows open pwsh and execute:

```pwsh
winget install Neovim.Neovim
```

This should also add neovim to the Path environment, but make sure it is added.
For convenience it could be helpful to have a separate environment variable for
Neovim that points to the nvim folder
to where the Repo was cloned.

Chocolatey might be helpful to install MingW and other missing tools that throw
errors in :checkhealth.

### Dependencies and Helpful Tools

#### MinGW (for windows)

MinGW is a compiler collection that includes the needed c compiler for windows.
There are other options, but I had the most
success with this one.

To install MinGW you need chocolatey currently, execute: ```choco install mingw```

#### Lazygit

Intall with choco: ```choco install lazygit```

### Troubleshooting

On windows with some language parser errors in treesitter can occur, for example
html and yaml.
Check [this][treesitter-help-link] for a solution.

What you have to do is to delete the libstdc++-6.dll that you can find in the
install location from neovim.
After that remove the nvim-data folder, restart the pc and let nvim initialize again.

## LSP

### Angular

For Angular Language Service to work you either have to be sure to install
typescript and angular/language-service as a dev dependency on the project or
TODO: find a solution for the
LSP setup to set the correct parameters automatically (LSP Zero seems to do that
correctly).

## Debugging

### dotNET

Install the netcoredbg adapter through Mason. Adjust the path to netcoredbg.exe!!!

## TODO

- Fix recording keys not working (it works just doesn't prompt that its recording)
- configure DAP for c# and typescript (partly finished)
- Adjust Readme to Linux
- autocomand to replace :q to bufdel or checkout mini bufremove
- Adjust omnisharp options
- textobjects ???
- Share clipboard with system
- Cleanup and simply after everything works as it should
- Check if lua snippets actually show up in cmp
- Define borderstyle for hover etc globally

## Plugins to consider

- [dap configs](https://github.com/ldelossa/nvim-dap-projects)
- [Neodev](https://github.com/folke/neodev.nvim)
- [Pick lsp formatter](https://github.com/fmbarina/pick-lsp-formatter.nvim)

[treesitter-help-link]: https://github.com/nvim-treesitter/nvim-treesitter/issues/3587#issuecomment-1306608973

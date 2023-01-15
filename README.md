![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

# CopperVim

These are my config files for Neovim. Big thanks to the Primageon for the initial setup guide.

## Install

Install Neovim.

For Windows open pwsh and execute:
```pwsh
winget install Neovim.Neovim
```

This should also add neovim to the Path environment, but make sure it is added.
For convenience it could be helpful to have a separate environment variable for Neovim.

Clone this repo and move the contents to folder that was specified for vim in the Path variable.

Normally this should look like this: C:/Users/<username>/AppData/Local/neovim

Open Neovim, open lua/copper/packer.lua and execute ```:PackerSync```, also execute ```:checkhealth``` to test for any
missing packages.

Maybe you need to :so first.

Chocolatey might be helpful to install MingW and other missing tools that throw errors in :checkhealth.

### Needed Packages from Chocolatey

For needed compilers execute: ```choco install mingw```

If running into problems with uv_dlopen remove everything treesitter related from config. Run PackerSync, make sure there
are no other Path environment variables for c other than mingw.

Reenable treesitter and the plugins requiring it. Run PackerSync again.

## TODO

- Add GUI Dashboard
- Fully enable and configure debugging (csharp)
- Automate installation process
- Move from packer to lazy


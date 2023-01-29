![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

# CopperVim

These are my config files for Neovim. Big thanks to the Primageon for the initial setup guide.

## Install

Clone this repo and move the contents to ```OS:/Users/<your-user-name/AppData/Local/nvim```

### Windows

For Windows open pwsh and execute:
```pwsh
winget install Neovim.Neovim
```

This should also add neovim to the Path environment, but make sure it is added.
For convenience it could be helpful to have a separate environment variable for Neovim that points to the nvim folder
to where the Repo was cloned.

Chocolatey might be helpful to install MingW and other missing tools that throw errors in :checkhealth.

### Needed Packages from Chocolatey

For needed compilers execute: ```choco install mingw```

### Troubleshooting

On windows with some language parser errors in treesitter can occur, for example html and yaml.
Check [this](https://github.com/nvim-treesitter/nvim-treesitter/issues/3587#issuecomment-1306608973) for a solution.

What you have to do is to delete the libstdc++-6.dll that you can find in the install location from neovim.
After that remove the nvim-data folder, restart the pc and let nvim initialize again.

## Debugging

### dotNET

Install the netcoredbg adapter through Mason. Adjust the path to netcoredbg.exe!!!

## TODO

- Fix all TODO tags
- configure DAP icons
- Automate installation process
- improve git workflow (lazygit?)
- Maybe Switch to bufferline as soon as it supports closing a singe buffer without picking
    - as well as fixing its bugs
- Checkout inline status ones its releases from nightly (curr avaivalable on 0.9)

## Plugins to consider

- [dap configs](https://github.com/ldelossa/nvim-dap-projects)
- [ALE](https://github.com/dense-analysis/ale)
- [Barbecue]()
- [Markdown Preview]()


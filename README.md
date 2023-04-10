![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

# CopperVim

These are my config files for Neovim.

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

### Dependencies and Helpful Tools

#### MinGW

MinGW is a compiler collection that includes the needed c compiler for windows. There are other options, but I had the most
success with this one.

To install MinGW you need chocolatey currently, execute: ```choco install mingw```

#### Lazygit

Intall with choco: ```choco install lazygit```

#### Python

MinGW comes bundled with Python. However it currently uses 3.9 and doesn't include pip.

Run ```winget install Python.Python.3.11``` (Or whatever version you want).

MinGw s installation has written some keys into the registry that leads to its version being picked up and used in the
Terminal when running a python command. To [fix](https://superuser.com/questions/433897/python-in-command-line-runs-the-wrong-version) this
we have to open the regedit and search for .py. The default key shows the reg key of where the default location for python.exe is picked up.

Go to ```HKEY_CLASSES_ROOT/Python.File/shell/open/command/@default```, where 'Python.File' is to be replaced with the data of the default key
from the previous step.
Go into shell/open/command and modify the default key here to point to the correct python.exe.

#### Pynvim

Pynvim is needed if nvim wants to use python. Install it with this command:

```'Path-to-python.exe' -m pip install pynvim```

#### Msys2 (Optional)

Needed for Ruby neovim.

Install: ```winget install msys2.msys2```

#### Ruby and Gem (Optional)

Install: ```winget install RubyInstallerTeam.Ruby.3.1```

Then run: ```gem install neovim```

### Troubleshooting

On windows with some language parser errors in treesitter can occur, for example html and yaml.
Check [this](https://github.com/nvim-treesitter/nvim-treesitter/issues/3587#issuecomment-1306608973) for a solution.

What you have to do is to delete the libstdc++-6.dll that you can find in the install location from neovim.
After that remove the nvim-data folder, restart the pc and let nvim initialize again.

## Debugging

### dotNET

Install the netcoredbg adapter through Mason. Adjust the path to netcoredbg.exe!!!

## TODO

- Fix recording keys not working
- configure DAP for c# and typescript
- Automate installation process

## Plugins to consider

- [dap configs](https://github.com/ldelossa/nvim-dap-projects)
- [Barbecue]()
- [Neodev](https://github.com/folke/neodev.nvim)

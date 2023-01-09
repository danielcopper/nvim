# CopperVIm

These are my config files for Neovim. Based on the suggestions from the Primeagen

## Install

Install Neovim.

For Windows open pwsh and execute:
```pwsh
winget install Neovim.Neovim
```

This should also add neovim to the Path environment, but make sure it is added.
For convenience it could be helpful to have a separate environment variable for Neovim.

Clone this repo and move the contents to folder that was specified for vim in the Path variable.

It should be something like this C:/Users/<username>/AppData/Local/neovim

Open Neovim and execute ```:PackerSync```, also execute ```:checkhealth``` to test for any
missing packages.

Chocolatey might be helpful to install MingW.


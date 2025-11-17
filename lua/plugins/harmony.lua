-- Harmony: Centralized theme and UI management system

return {
  -- dir = "~/Repos/nvim-harmony",
  "danielcopper/nvim-harmony",
  name = "harmony",
  lazy = false,
  priority = 1000, -- Load early to ensure harmony loads before themed plugins
  init = function()
    -- Configure Neovim built-ins (diagnostics, LSP, fillchars) before plugins load
    require("harmony.builtins").setup_early()
  end,
  config = function()
    require("harmony").setup({
      colorscheme = {
        name = "catppuccin",
        variant = "mocha",
      },
      borders = "none",
      transparency = {
        enabled = false,
      },
    })
  end,
}

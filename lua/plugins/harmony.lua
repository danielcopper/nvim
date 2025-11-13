-- Harmony: Centralized theme and UI management system

return {
  "danielcopper/nvim-harmony",
  name = "harmony",
  -- priority = 1000, -- Load early, before other UI plugins
  lazy = false,
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

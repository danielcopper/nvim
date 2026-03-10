-- Colorscheme configuration
-- Change these values to switch colorschemes.
vim.g.colorscheme_config = {
  colorscheme = "catppuccin", -- "catppuccin" | "rose-pine" | "kanagawa" | "kanso" | "oasis"
  variant = "mocha",          -- colorscheme-specific variant
  borders = "none",           -- "none" | "rounded" | "single" | "double"
}

return require("plugins.colorschemes." .. vim.g.colorscheme_config.colorscheme)

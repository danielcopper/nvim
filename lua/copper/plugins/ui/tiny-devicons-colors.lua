return {
  "rachartier/tiny-devicons-auto-colors.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  event = "VeryLazy",
  config = function()
    -- You can add as many colors as you like. More colors is better to estimate the nearest color for each devicon.
    local theme_colors = require("catppuccin.palettes").get_palette("macchiato")

    require('tiny-devicons-auto-colors').setup({
      colors = theme_colors,
    })
  end
}

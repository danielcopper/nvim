local icons = require("copper.config.icons")

return {
  -- Show a lightbulb where codeactions are available
  {
    "kosayoda/nvim-lightbulb",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
        priority = 101,
        sign = {
          enabled = true,
          -- Text to show in the sign column.
          -- Must be between 1-2 characters.
          text = icons.ui.Lightbulb,
          -- Highlight group to highlight the sign column text.
          hl = "LightBulbSign",
        },
      })
    end,
  },
}

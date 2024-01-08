return {
  -- Improves the UI for input and select options
  -- for example for code actions
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        border = vim.copper_config.borders
      },
      select = {
        -- telescope = require('telescope.themes').get_ivy({
        --   borderchars = vim.copper_config.borders == "none" and { " " } or { vim.copper_config.borders },
        -- }),
        telescope = require('telescope.themes').get_dropdown({
          borderchars = vim.copper_config.borders == "none" and { " " } or { vim.copper_config.borders },
        }),
      }
    }
  },
}

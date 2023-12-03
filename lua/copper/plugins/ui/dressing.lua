return {
  -- Improves the UI for input and select options
  -- for example for code actions
  -- TODO: test whichone works better
  { "stevearc/dressing.nvim", event = "VeryLazy", config = true },

  -- {
  --   "stevearc/dressing.nvim",
  --   init = function()
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     vim.ui.select = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.select(...)
  --     end
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     vim.ui.input = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.input(...)
  --     end
  --   end,
  -- },
}

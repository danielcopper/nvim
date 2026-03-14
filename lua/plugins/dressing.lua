-- Dressing: Better vim.ui.input

return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      enabled = true,
    },
    select = {
      enabled = false, -- Using telescope-ui-select instead
    },
  },
}

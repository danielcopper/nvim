return {
  "rachartier/tiny-inline-diagnostic.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    vim.diagnostic.config({ virtual_text = false })
    require('tiny-inline-diagnostic').setup()
  end
}

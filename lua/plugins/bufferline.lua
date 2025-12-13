return {
  "akinsho/bufferline.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "neovim/nvim-lspconfig",
  },
  opts = function()
    return {
      options = {
        style_preset = require("bufferline").style_preset.sloped,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
        show_close_icon = false,
        show_buffer_close_icons = true,
        hover = {
          enabled = true,
          delay = 0,
          reveal = { "close" },
        },
      },
    }
  end,
}

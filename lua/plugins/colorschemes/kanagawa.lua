local cfg = vim.g.colorscheme_config
local variant = cfg.variant or "wave"
local borders = cfg.borders or "rounded"

local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

return {
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = variant,
        dimInactive = true,
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  { "nvim-telescope/telescope.nvim", opts = {
    defaults = { borderchars = borderchars },
    extensions = { ["ui-select"] = { borderchars = borderchars } },
  }},

  { "rcarriga/nvim-notify", opts = { background_colour = "#1f1f28" } },
  { "folke/noice.nvim", opts = {
    views = {
      cmdline_popup = { border = { style = borders, padding = { 0, 1 } } },
      popupmenu = { border = { style = borders } },
      hover = { border = { style = borders, padding = { 1, 2 } } },
    },
    presets = { lsp_doc_border = true },
  }},
  { "williamboman/mason.nvim", opts = { ui = { border = borders } } },
  { "folke/which-key.nvim", opts = { win = { border = borders } } },
}

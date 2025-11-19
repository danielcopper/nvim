local settings = require("config.theme.settings")

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    enabled = settings.colorscheme.name == "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = settings.colorscheme.variant or "mocha",
        dim_inactive = {
          enabled = settings.dim_inactive,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    enabled = settings.colorscheme.name == "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = settings.colorscheme.variant or "main",
        dim_inactive_windows = settings.dim_inactive,
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    enabled = settings.colorscheme.name == "kanagawa",
    config = function()
      require("kanagawa").setup({
        theme = settings.colorscheme.variant or "wave",
        dimInactive = settings.dim_inactive,
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  {
    "webhooked/kanso.nvim",
    name = "kanso",
    lazy = false,
    priority = 1000,
    enabled = settings.colorscheme.name == "kanso",
    config = function()
      vim.cmd.colorscheme("kanso")
    end,
  },
}

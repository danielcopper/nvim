local config = {
  colorscheme = "catppuccin",
  flavor = vim.g.catppuccin_flavor or "mocha",
  transparent = vim.g.transparent_bg or false,
  borders = "rounded",
}

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = function()
    return {
      flavour = config.flavor,
      transparent_background = config.transparent,

      integrations = {
        alpha = true,
        barbecue = {
          dim_dirname = true,
          bold_basename = true,
          dim_context = false,
        },
        blink_cmp = true,
        cmp = true,
        dap = true,
        dap_ui = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = true,
        noice = true,
        notify = true,
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },

      custom_highlights = function(colors)
        return {
          FloatBorder = { fg = colors.blue },
          TelescopeBorder = { fg = colors.blue },
          CursorLineNr = { fg = colors.peach, style = { "bold" } },
          Comment = { fg = colors.overlay2, style = { "italic" } },
        }
      end,
    }
  end,

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme(config.colorscheme)

    vim.g.border_style = config.borders
  end,
}

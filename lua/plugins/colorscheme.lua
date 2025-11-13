local config = {
  colorscheme = "catppuccin",
  flavor = vim.g.catppuccin_flavor or "mocha",
  transparent = vim.g.transparent_bg or false,
  -- borders = "rounded",
}

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = config.colorscheme ~= "catppuccin",
    priority = 1000,
    opts = function()
      return {
        flavour = config.flavor,
        transparent_background = config.transparent,
        integrations = {
          alpha = true,
          barbecue = { dim_dirname = true, bold_basename = true, dim_context = false },
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
            CursorLineNr = { fg = colors.peach, style = { "bold" } },
            Comment = { fg = colors.overlay2, style = { "italic" } },
            -- Telescope highlights are now handled by harmony
          }
        end,
      }
    end,
    config = function(_, opts)
      if config.colorscheme == "catppuccin" then
        require("catppuccin").setup(opts)
        -- Colorscheme loading is now handled by harmony
      end
    end,
  },

  {
    "webhooked/kanso.nvim",
    lazy = config.colorscheme ~= "kanso",
    priority = 1000,
    opts = {},
    config = function(_, opts)
      if config.colorscheme == "kanso" then
        require("kanso").setup(opts)
        -- Colorscheme loading is now handled by harmony
      end
    end,
  },
}

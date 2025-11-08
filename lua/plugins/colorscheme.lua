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
            FloatBorder = { fg = colors.blue },
            CursorLineNr = { fg = colors.peach, style = { "bold" } },
            Comment = { fg = colors.overlay2, style = { "italic" } },

            -- Telescope NvChad-style with subtle backgrounds and toned down borders
            TelescopePromptNormal = { bg = colors.surface0 },
            TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
            TelescopePromptTitle = { bg = colors.surface0, fg = colors.surface0 },

            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopeResultsTitle = { bg = colors.mantle, fg = colors.mantle },

            TelescopePreviewNormal = { bg = colors.crust },
            TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
            TelescopePreviewTitle = { bg = colors.crust, fg = colors.crust },
          }
        end,
      }
    end,
    config = function(_, opts)
      if config.colorscheme == "catppuccin" then
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
        -- vim.g.border_style = config.borders
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
        vim.cmd.colorscheme("kanso")
        -- vim.g.border_style = config.borders
      end
    end,
  },
}

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "rose-pine",
    opts = {
      --- @usage 'auto'|'main'|'moon'|'dawn'
      variant = "auto",
      --- @usage 'main'|'moon'|'dawn'
      dark_variant = "main",
      styles = {
        transparency = vim.copper_config.transparency
      },
      highlight_groups = {
        Comment = { italic = true },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "catppuccin",
    opts = {
      transparent_background = vim.copper_config.transparency,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = true,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        barbecue = {
          dim_dirname = true, -- directory name is dimmed by default
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        bufferline = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        markdown = true,
        mason = true,
        noice = true,
        cmp = true,
        dap = {
          enabled = true,
          enable_ui = true, -- enable nvim-dap-ui
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        notify = true,
        telescope = {
          enabled = true,
          -- style = "nvchad"
        },
        which_key = true,
        lsp_trouble = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Create an autocommand group for Neo-tree highlight customization
      local group = vim.api.nvim_create_augroup("NeoTreeTransparentBackground", { clear = true })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
          if vim.copper_config.transparency then
            vim.cmd("highlight NeoTreeNormalNC guibg=NONE ctermbg=NONE")
          end
        end
      })
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "tokyonight",
    opts = {
      style = "night",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      light_style = "day",    -- The theme is used when the background is set to light
      transparent = vim.copper_config.transparency,     -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "kanagawa",
    opts = {
      compile = false,
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = vim.copper_config.transparency,
      dimInactive = false,     -- dim inactive window `:h hl-NormalNC`
      terminalColors = true,   -- define vim.g.terminal_color_{0,17}
      variablebuiltinStyle = { italic = true },
      specialReturn = true,    -- special highlight for the return keyword
      specialException = true, -- special highlight for exception handling keywords
      globalStatus = true,     -- adjust window separators highlight for laststatus=3
      colors = {
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {},
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Transparent Floating Windows
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          StatusLine = { bg = "none" },   -- Making status line background transparent
          StatusLineNC = { bg = "none" }, -- Making non-current status line transparent
          TelescopeBorder = { bg = "none", fg = "none" },
        }
      end,
      theme = "wave",
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  {
    -- 'sainnhe/everforest',
    "neanias/everforest-nvim",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "everforest",
    opts = {
      -- 2 will have more UI components be transparent (e.g. status line
      -- background).
      transparent_background_level = 1,
      italics = true,
      disable_italic_comments = false,
    },
    config = function(_, opts)
      require("everforest").setup(opts)
      vim.cmd.colorscheme("everforest")
    end,
  },

  {
    "chriskempson/base16-vim",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "base16",
    config = function()
      vim.g.base16colorspace = 256
      -- vim.cmd.colorscheme("base16-default-dark")
      vim.cmd.colorscheme("base16-tomorrow-night")
      vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
    end,
  },

  {
    "kvrohit/rasmus.nvim",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "rasmus",
    config = function()
      vim.g.rasmus_transparent = vim.copper_config.transparency
      vim.cmd.colorscheme("rasmus")
    end,
  },

  {
    "fynnfluegge/monet.nvim",
    name = "monet",
    priority = 1000,
    cond = vim.copper_config.colorscheme == "monet",
    opts = {
      transparent_background = vim.copper_config.transparency,
      styles = {
        comments = { "italic" }
      }
    },
    config = function(_, opts)
      require("monet").setup(opts)
      vim.cmd.colorscheme("monet")
    end
  },

  {
    "askfiy/killer-queen",
    priority = 100,
    cond = vim.copper_config.colorscheme == "killer-queen",
    opts = {
      -- is_border = true,
      transparent = vim.copper_config.transparency,
    },
    config = function(_, opts)
      require("killer-queen").setup(opts)
      vim.cmd([[colorscheme killer-queen]])
    end,
  },
}

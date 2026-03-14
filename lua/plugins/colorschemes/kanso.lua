local cfg = vim.g.colorscheme_config
local variant = cfg.variant or "ink"
local borders = cfg.borders or "none"

local borderchars = borders == "none"
  and { " ", " ", " ", " ", " ", " ", " ", " " }
  or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

return {
  {
    "webhooked/kanso.nvim",
    name = "kanso",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanso").setup({
        background = { dark = variant, light = variant },
        foreground = "saturated",
        dimInactive = true,
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        overrides = function(colors)
          local hl = {}

          if borders == "none" then
            local p = colors.palette

            -- Telescope
            hl.TelescopeNormal = { bg = p.zenBg0, fg = p.fg }
            hl.TelescopeBorder = { bg = p.zenBg0, fg = p.zenBg0 }
            hl.TelescopePromptNormal = { bg = p.zenBg3, fg = p.fg }
            hl.TelescopePromptBorder = { bg = p.zenBg3, fg = p.zenBg3 }
            hl.TelescopePromptTitle = { fg = p.zenBg0, bg = p.redSaturated, bold = true }
            hl.TelescopePromptPrefix = { fg = p.redSaturated, bg = p.zenBg3 }
            hl.TelescopeResultsNormal = { bg = p.zenBg2, fg = p.fg }
            hl.TelescopeResultsBorder = { bg = p.zenBg2, fg = p.zenBg2 }
            hl.TelescopeResultsTitle = { fg = p.zenBg0, bg = p.blueSaturated, bold = true }
            hl.TelescopePreviewNormal = { bg = p.zenBg1, fg = p.fg }
            hl.TelescopePreviewBorder = { bg = p.zenBg1, fg = p.zenBg1 }
            hl.TelescopePreviewTitle = { fg = p.zenBg0, bg = p.greenSaturated, bold = true }
            hl.TelescopeSelection = { bg = p.zenBg3, fg = p.fg, bold = true }
            hl.TelescopeSelectionCaret = { fg = p.blueSaturated, bg = p.zenBg3, bold = true }
            hl.TelescopeMatching = { fg = p.blueSaturated, bold = true }

            -- Noice cmdline
            hl.NoiceCmdlineNormal = { bg = p.zenBg2, fg = p.fg }
            hl.NoiceCmdlineBorder = { bg = p.zenBg2, fg = p.zenBg2 }
            hl.NoiceCmdlinePopup = { bg = p.zenBg2, fg = p.fg }
            hl.NoiceCmdlinePopupBorder = { bg = p.zenBg2, fg = p.zenBg2 }
            hl.NoiceCmdline = { bg = p.zenBg2, fg = p.fg }

            -- CMP
            hl.BlinkCmpMenu = { bg = p.zenBg2, fg = p.fg }
            hl.BlinkCmpMenuBorder = { fg = p.zenBg2, bg = p.zenBg2 }
            hl.BlinkCmpMenuSelection = { bg = p.zenBg3, fg = p.fg, bold = true }
            hl.BlinkCmpDoc = { bg = p.zenBg0, fg = p.fg }
            hl.BlinkCmpDocBorder = { fg = p.zenBg0, bg = p.zenBg0 }
          end

          return hl
        end,
      })
      vim.cmd.colorscheme("kanso")
    end,
  },

  -- Inject visual config into other plugins

  { "nvim-telescope/telescope.nvim", opts = {
    defaults = { borderchars = borderchars },
    extensions = { ["ui-select"] = { borderchars = borderchars } },
  }},

  { "rcarriga/nvim-notify", opts = {
    background_colour = "#0d0d0d", -- kanso ink base (approx)
  }},

  { "folke/noice.nvim", opts = {
    views = {
      cmdline_popup = {
        border = { style = borders, padding = borders == "none" and { 1, 1 } or { 0, 1 } },
      },
      popupmenu = { border = { style = borders } },
      hover = { border = { style = borders, padding = { 1, 2 } } },
    },
    presets = { lsp_doc_border = borders ~= "none" },
  }},

  { "williamboman/mason.nvim", opts = { ui = { border = borders } } },
  { "folke/which-key.nvim", opts = { win = { border = borders } } },
  { "neovim/nvim-lspconfig", opts = { diagnostics = { float = { border = borders } } } },

  { "saghen/blink.cmp", opts = {
    completion = {
      menu = { border = borders },
      documentation = { window = { border = borders } },
    },
    signature = { window = { border = borders } },
  }},
}

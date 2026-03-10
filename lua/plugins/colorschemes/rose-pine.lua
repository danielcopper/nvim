local cfg = vim.g.colorscheme_config
local variant = cfg.variant or "main"
local borders = cfg.borders or "none"

local borderchars = borders == "none"
  and { " ", " ", " ", " ", " ", " ", " ", " " }
  or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      local hl = {}

      if borders == "none" then
        hl.TelescopeNormal = { bg = "base", fg = "text" }
        hl.TelescopeBorder = { bg = "base", fg = "base" }
        hl.TelescopePromptNormal = { bg = "surface", fg = "text" }
        hl.TelescopePromptBorder = { bg = "surface", fg = "surface" }
        hl.TelescopePromptTitle = { fg = "base", bg = "love", bold = true }
        hl.TelescopePromptPrefix = { fg = "love", bg = "surface" }
        hl.TelescopeResultsNormal = { bg = "overlay", fg = "text" }
        hl.TelescopeResultsBorder = { bg = "overlay", fg = "overlay" }
        hl.TelescopeResultsTitle = { fg = "base", bg = "pine", bold = true }
        hl.TelescopePreviewNormal = { bg = "highlight_med", fg = "text" }
        hl.TelescopePreviewBorder = { bg = "highlight_med", fg = "highlight_med" }
        hl.TelescopePreviewTitle = { fg = "base", bg = "foam", bold = true }
        hl.TelescopeSelection = { bg = "highlight_med", fg = "text", bold = true }
        hl.TelescopeSelectionCaret = { fg = "iris", bg = "highlight_med", bold = true }
        hl.TelescopeMatching = { fg = "iris", bold = true }
      end

      -- Fidget / float backgrounds
      hl.FloatNormal = { bg = "base", fg = "text" }
      hl.FloatBorder = { bg = "base", fg = "muted" }
      hl.EndOfBuffer = { fg = "base" }

      require("rose-pine").setup({
        variant = variant,
        dim_inactive_windows = true,
        styles = { transparency = false },
        highlight_groups = hl,
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  -- Inject visual config into other plugins

  { "nvim-telescope/telescope.nvim", opts = {
    defaults = { borderchars = borderchars },
    extensions = { ["ui-select"] = { borderchars = borderchars } },
  }},

  { "rcarriga/nvim-notify", opts = {
    background_colour = "#191724", -- rose-pine base
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
  { "folke/snacks.nvim", opts = { lazygit = { win = { border = borders } } } },
  { "neovim/nvim-lspconfig", opts = { diagnostics = { float = { border = borders } } } },

  { "saghen/blink.cmp", opts = {
    completion = {
      menu = { border = borders },
      documentation = { window = { border = borders } },
    },
    signature = { window = { border = borders } },
  }},
}

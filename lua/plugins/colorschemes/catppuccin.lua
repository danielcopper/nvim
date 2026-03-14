local cfg = vim.g.colorscheme_config
local variant = cfg.variant or "mocha"
local borders = cfg.borders or "none"

-- Borderchars: spaces for borderless, box-drawing for bordered
local borderchars = borders == "none"
  and { " ", " ", " ", " ", " ", " ", " ", " " }
  or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

return {
  -- Catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = variant,
        dim_inactive = { enabled = true },
        custom_highlights = function(colors)
          local hl = {}

          if borders == "none" then
            -- Telescope: layered backgrounds for borderless look
            hl.TelescopeNormal = { bg = colors.base, fg = colors.text }
            hl.TelescopeBorder = { bg = colors.base, fg = colors.base }
            hl.TelescopePromptNormal = { bg = colors.base, fg = colors.text }
            hl.TelescopePromptBorder = { bg = colors.base, fg = colors.base }
            hl.TelescopePromptTitle = { fg = colors.crust, bg = colors.maroon, bold = true }
            hl.TelescopePromptPrefix = { fg = colors.maroon, bg = colors.base }
            hl.TelescopeResultsNormal = { bg = colors.mantle, fg = colors.text }
            hl.TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle }
            hl.TelescopeResultsTitle = { fg = colors.crust, bg = colors.sapphire, bold = true }
            hl.TelescopePreviewNormal = { bg = colors.crust, fg = colors.text }
            hl.TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust }
            hl.TelescopePreviewTitle = { fg = colors.crust, bg = colors.green, bold = true }
            hl.TelescopeSelection = { bg = colors.surface1, fg = colors.text, bold = true }
            hl.TelescopeSelectionCaret = { fg = colors.blue, bg = colors.surface1, bold = true }
            hl.TelescopeMatching = { fg = colors.blue, bold = true }

            -- Noice cmdline
            hl.NoiceCmdlineNormal = { bg = colors.surface0, fg = colors.text }
            hl.NoiceCmdlineBorder = { bg = colors.surface0, fg = colors.surface0 }

            -- Blink completion menu
            hl.BlinkCmpMenu = { bg = colors.surface0, fg = colors.text }
            hl.BlinkCmpMenuBorder = { fg = colors.surface0, bg = colors.surface0 }
            hl.BlinkCmpMenuSelection = { bg = colors.surface1, fg = colors.text, bold = true }
            hl.BlinkCmpDoc = { bg = colors.mantle, fg = colors.text }
            hl.BlinkCmpDocBorder = { fg = colors.mantle, bg = colors.mantle }
          end

          -- Notify highlights
          local notify_bg = colors.crust
          hl.NotifyBackground = { fg = colors.text, bg = notify_bg }
          for _, level in ipairs({
            { name = "ERROR", color = colors.red },
            { name = "WARN", color = colors.yellow },
            { name = "INFO", color = colors.blue },
            { name = "DEBUG", color = colors.teal },
            { name = "TRACE", color = colors.mauve },
          }) do
            hl["Notify" .. level.name .. "Border"] = { fg = level.color, bg = notify_bg }
            hl["Notify" .. level.name .. "Icon"] = { fg = level.color, bg = notify_bg }
            hl["Notify" .. level.name .. "Title"] = { fg = level.color, bg = notify_bg, bold = true }
            hl["Notify" .. level.name .. "Body"] = { fg = colors.text, bg = notify_bg }
          end
          hl.NotifyLogTime = { fg = colors.subtext0, bg = notify_bg }
          hl.NotifyLogTitle = { fg = colors.text, bg = notify_bg }

          return hl
        end,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Inject visual config into other plugins via Lazy spec merging

  { "nvim-telescope/telescope.nvim", opts = {
    defaults = { borderchars = borderchars },
    extensions = { ["ui-select"] = { borderchars = borderchars } },
  }},

  { "rcarriga/nvim-notify", opts = {
    background_colour = "#11111b", -- catppuccin mocha crust
  }},

  { "folke/noice.nvim", opts = {
    views = {
      cmdline_popup = {
        border = {
          style = borders,
          padding = borders == "none" and { 1, 1 } or { 0, 1 },
        },
        win_options = {
          winhighlight = "Normal:NoiceCmdlineNormal,FloatBorder:NoiceCmdlineBorder",
        },
      },
      popupmenu = { border = { style = borders } },
      hover = { border = { style = borders, padding = { 1, 2 } } },
    },
    presets = {
      lsp_doc_border = borders ~= "none",
    },
  }},

  { "williamboman/mason.nvim", opts = { ui = { border = borders } } },
  { "folke/which-key.nvim", opts = { win = { border = borders } } },
  { "neovim/nvim-lspconfig", opts = {
    diagnostics = { float = { border = borders } },
  }},

  { "saghen/blink.cmp", opts = {
    completion = {
      menu = { border = borders },
      documentation = { window = { border = borders } },
    },
    signature = { window = { border = borders } },
  }},

  -- Lualine color overrides
  { "nvim-lualine/lualine.nvim", opts = function(_, opts)
    local ok, palettes = pcall(require, "catppuccin.palettes")
    if not ok or not opts.sections then return end
    local p = palettes.get_palette(variant)

    -- Apply palette colors to specific lualine_b components
    for _, comp in ipairs(opts.sections.lualine_b or {}) do
      if not comp.color then
        comp.color = { fg = p.text }
      end
    end

    -- Apply colors to lualine_x components
    local x = opts.sections.lualine_x or {}
    -- Color specific sections by index
    -- x[1] = diagnostics (handled by lualine)
    -- x[2] = Ln/Col
    if x[2] then x[2].color = { fg = p.overlay1 } end
    -- x[3] = LSP clients (green/gray handled dynamically in lualine.lua)
    -- x[4] = Encoding
    if x[4] then x[4].color = { fg = p.mauve } end
    -- x[5] = Fileformat (conditional)
    -- x[6] = Filetype
    if x[6] then x[6].color = { fg = p.blue } end
  end},
}

-- All custom highlight overrides
-- Loaded in init.lua after colorscheme loads
-- Conditionally applies highlights based on colorscheme + borders combination

local settings = require("config.theme.settings")

local M = {}

function M.setup()
  -- ==========================================================================
  -- Telescope Highlights (Catppuccin + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "catppuccin" and settings.borders == "none" then
    -- Get catppuccin palette dynamically based on variant setting
    local palette = require("catppuccin.palettes").get_palette(settings.colorscheme.variant or "mocha")
    local catppuccin_alt_bg = settings.colorscheme.catppuccin_alt_bg

    -- Main window
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.base, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = palette.base, fg = palette.base })

    -- Prompt (input area) - lighter background
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = palette.surface0, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = palette.surface0, fg = palette.surface0 })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = palette.crust, bg = palette.maroon, bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = palette.maroon, bg = palette.surface0 })

    -- Results (list area) - use alt_bg for distinction from preview
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = catppuccin_alt_bg, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = catppuccin_alt_bg, fg = catppuccin_alt_bg })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = palette.crust, bg = palette.sapphire, bold = true })

    -- Preview (preview area)
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = palette.base, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = palette.base, fg = palette.base })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = palette.crust, bg = palette.green, bold = true })

    -- Selection highlight
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = palette.surface1, fg = palette.text, bold = true })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = palette.blue, bg = palette.surface1, bold = true })

    -- Matching text (fuzzy match)
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.blue, bold = true })
  end

  -- ==========================================================================
  -- Telescope Highlights (Rose-pine + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "rose-pine" and settings.borders == "none" then
    local palette = require("rose-pine.palette")

    -- Main window
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.base, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = palette.base, fg = palette.base })

    -- Prompt (input area) - lighter background
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = palette.surface, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = palette.surface, fg = palette.surface })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = palette.base, bg = palette.love, bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = palette.love, bg = palette.surface })

    -- Results (list area) - overlay background
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = palette.overlay, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = palette.overlay, fg = palette.overlay })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = palette.base, bg = palette.pine, bold = true })

    -- Preview (preview area) - lighter background
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = palette.highlight_med, fg = palette.text })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = palette.highlight_med, fg = palette.highlight_med })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = palette.base, bg = palette.foam, bold = true })

    -- Selection highlight
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = palette.highlight_med, fg = palette.text, bold = true })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = palette.iris, bg = palette.highlight_med, bold = true })

    -- Matching text (fuzzy match)
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.iris, bold = true })
  end

  -- ==========================================================================
  -- Noice Highlights (Catppuccin + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "catppuccin" and settings.borders == "none" then
    local palette = require("catppuccin.palettes").get_palette(settings.colorscheme.variant or "mocha")

    -- Cmdline with darker background
    vim.api.nvim_set_hl(0, "NoiceCmdlineNormal", { bg = palette.surface0, fg = palette.text })
    vim.api.nvim_set_hl(0, "NoiceCmdlineBorder", { bg = palette.surface0, fg = palette.surface0 })
  end

  -- ==========================================================================
  -- CMP Highlights (Catppuccin + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "catppuccin" and settings.borders == "none" then
    local palette = require("catppuccin.palettes").get_palette(settings.colorscheme.variant or "mocha")
    local catppuccin_alt_bg = settings.colorscheme.catppuccin_alt_bg

    vim.api.nvim_set_hl(0, "CmpPmenu", { bg = catppuccin_alt_bg, fg = palette.text, italic = true })
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = catppuccin_alt_bg, bg = catppuccin_alt_bg }) -- Invisible: fg = bg
    vim.api.nvim_set_hl(0, "CmpSel", { bg = palette.surface1, fg = palette.text, bold = true })

    -- Documentation window with darker background (mantle) for distinction
    vim.api.nvim_set_hl(0, "CmpDoc", { bg = palette.mantle, fg = palette.text })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = palette.mantle, bg = palette.mantle }) -- Invisible: fg = bg
  end

  -- ==========================================================================
  -- Telescope Highlights (Kanso + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "kanso" and settings.borders == "none" then
    -- Get kanso colors dynamically based on variant and foreground setting
    local kanso_colors = require("kanso.colors").setup({
      theme = settings.colorscheme.variant or "ink",
      foreground = "saturated",
    })
    local palette = kanso_colors.palette
    local theme = kanso_colors.theme

    -- Main window - base background
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = palette.zenBg0, fg = palette.fg })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = palette.zenBg0, fg = palette.zenBg0 })

    -- Prompt (input area) - lightest background
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = palette.zenBg3, fg = palette.fg })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = palette.zenBg3, fg = palette.zenBg3 })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = palette.zenBg0, bg = palette.redSaturated, bold = true })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = palette.redSaturated, bg = palette.zenBg3 })

    -- Results (list area) - medium background for distinction
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = palette.zenBg2, fg = palette.fg })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = palette.zenBg2, fg = palette.zenBg2 })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = palette.zenBg0, bg = palette.blueSaturated, bold = true })

    -- Preview (preview area) - slightly lighter than base
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = palette.zenBg1, fg = palette.fg })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = palette.zenBg1, fg = palette.zenBg1 })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = palette.zenBg0, bg = palette.greenSaturated, bold = true })

    -- Selection highlight
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = palette.zenBg3, fg = palette.fg, bold = true })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = palette.blueSaturated, bg = palette.zenBg3, bold = true })

    -- Matching text (fuzzy match)
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = palette.blueSaturated, bold = true })
  end

  -- ==========================================================================
  -- Noice Highlights (Kanso + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "kanso" and settings.borders == "none" then
    local kanso_colors = require("kanso.colors").setup({
      theme = settings.colorscheme.variant or "ink",
      foreground = "saturated",
    })
    local palette = kanso_colors.palette

    -- Cmdline with lighter background (custom groups from noice config)
    vim.api.nvim_set_hl(0, "NoiceCmdlineNormal", { bg = palette.zenBg2, fg = palette.fg })
    vim.api.nvim_set_hl(0, "NoiceCmdlineBorder", { bg = palette.zenBg2, fg = palette.zenBg2 })

    -- Also set default Noice highlight groups in case custom winhighlight isn't applied
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = palette.zenBg2, fg = palette.fg })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { bg = palette.zenBg2, fg = palette.zenBg2 })
    vim.api.nvim_set_hl(0, "NoiceCmdline", { bg = palette.zenBg2, fg = palette.fg })
  end

  -- ==========================================================================
  -- CMP Highlights (Kanso + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "kanso" and settings.borders == "none" then
    local kanso_colors = require("kanso.colors").setup({
      theme = settings.colorscheme.variant or "ink",
      foreground = "saturated",
    })
    local palette = kanso_colors.palette

    vim.api.nvim_set_hl(0, "CmpPmenu", { bg = palette.zenBg2, fg = palette.fg, italic = true })
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = palette.zenBg2, bg = palette.zenBg2 }) -- Invisible: fg = bg
    vim.api.nvim_set_hl(0, "CmpSel", { bg = palette.zenBg3, fg = palette.fg, bold = true })

    -- Documentation window with base background for distinction
    vim.api.nvim_set_hl(0, "CmpDoc", { bg = palette.zenBg0, fg = palette.fg })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = palette.zenBg0, bg = palette.zenBg0 }) -- Invisible: fg = bg
  end
end

-- Auto-reapply highlights when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("theme_highlights", { clear = true }),
  callback = function()
    -- Small delay to let colorscheme fully apply first
    vim.defer_fn(M.setup, 50)
  end,
})

-- Apply highlights immediately when module is loaded (in case colorscheme is already active)
-- Use defer_fn to ensure colorscheme is fully loaded
vim.defer_fn(M.setup, 100)

return M

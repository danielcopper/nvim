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
  -- Noice Highlights (Catppuccin + Borderless)
  -- ==========================================================================

  if settings.colorscheme.name == "catppuccin" and settings.borders == "none" then
    local palette = require("catppuccin.palettes").get_palette(settings.colorscheme.variant or "mocha")

    -- Cmdline with darker background
    vim.api.nvim_set_hl(0, "NoiceCmdlineNormal", { bg = palette.surface0, fg = palette.text })
    vim.api.nvim_set_hl(0, "NoiceCmdlineBorder", { bg = palette.surface0, fg = palette.surface0 })
  end

  -- ==========================================================================
  -- CMP Highlights (Catppuccin)
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
end

-- Auto-reapply highlights when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("theme_highlights", { clear = true }),
  callback = function()
    -- Small delay to let colorscheme fully apply first
    vim.defer_fn(M.setup, 50)
  end,
})

return M

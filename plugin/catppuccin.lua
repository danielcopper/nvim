vim.pack.add({ "https://github.com/catppuccin/nvim" })

local ui = require("ui")
local variant = "mocha"
local borders = ui.borders

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

      -- Noice confirm (Save/Quit prompts) — match cmdline scheme
      hl.NoiceConfirm = { bg = colors.surface0, fg = colors.text }
      hl.NoiceConfirmBorder = { bg = colors.surface0, fg = colors.surface0 }

      -- Blink completion menu: dark crust bg, warm peach selection
      hl.BlinkCmpMenu = { bg = colors.crust, fg = colors.text }
      hl.BlinkCmpMenuBorder = { fg = colors.crust, bg = colors.crust }
      hl.BlinkCmpMenuSelection = { bg = colors.peach, fg = colors.crust, bold = true }
      hl.BlinkCmpDoc = { bg = colors.mantle, fg = colors.text }
      hl.BlinkCmpDocBorder = { fg = colors.mantle, bg = colors.mantle }
      hl.BlinkCmpKind = { fg = colors.overlay1, bg = colors.crust }

      -- Generic floats
      hl.NormalFloat = { bg = colors.crust, fg = colors.text }
      hl.FloatBorder = { bg = colors.crust, fg = colors.crust }
      hl.FloatTitle = { bg = colors.peach, fg = colors.crust, bold = true }
      hl.FloatFooter = { bg = colors.crust, fg = colors.overlay1 }
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

-- Enforce borderless float highlights after every colorscheme load
local function apply_float_hl()
  local ok, palettes = pcall(require, "catppuccin.palettes")
  if not ok then return end
  local p = palettes.get_palette(variant)
  if borders == "none" then
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = p.crust, fg = p.text })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = p.crust, fg = p.crust })
    vim.api.nvim_set_hl(0, "FloatTitle", { bg = p.peach, fg = p.crust, bold = true })
    vim.api.nvim_set_hl(0, "FloatFooter", { bg = p.crust, fg = p.overlay1 })
  end
end
apply_float_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("catppuccin_float_hl", { clear = true }),
  pattern = "catppuccin*",
  callback = apply_float_hl,
})

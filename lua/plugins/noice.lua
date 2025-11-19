-- Noice: Better UI for messages, cmdline, and popupmenu

local helpers = require("config.theme.helpers")
local settings = require("config.theme.settings")

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = function()
    local border = helpers.get_border()

    return {
      views = {
        cmdline_popup = {
          border = {
            style = border,
            padding = border == "none" and { 1, 1 } or { 0, 1 },
          },
          win_options = {
            winhighlight = "Normal:NoiceCmdlineNormal,FloatBorder:NoiceCmdlineBorder",
          },
        },
        popupmenu = {
          border = {
            style = border,
          },
        },
        hover = {
          border = {
            style = border,
            padding = { 1, 2 },
          },
        },
      },
    lsp = {
      -- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      -- Noice handles hover and signature help
      hover = {
        enabled = true,
      },
      signature = {
        enabled = true,
      },
      progress = {
        enabled = false, -- Using fidget.nvim for LSP progress
      },
    },
      -- Presets for easier configuration
      presets = {
        bottom_search = true,         -- Use classic bottom search
        command_palette = true,        -- Position the cmdline and popupmenu together
        long_message_to_split = true,  -- Long messages sent to split
        inc_rename = false,            -- Not using inc_rename.nvim
        lsp_doc_border = border ~= "none", -- Add border to hover and signature help only when borders enabled
      },
      -- Routes for message handling
      routes = {
        {
          filter = {
            event = "notify",
          },
          view = "notify", -- Route notifications to nvim-notify
        },
      },
    }
  end,
}

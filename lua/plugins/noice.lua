-- Noice: Better UI for messages, cmdline, and popupmenu

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
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
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
      },
    },
    -- Presets for easier configuration
    presets = {
      bottom_search = true,         -- Use classic bottom search
      command_palette = true,        -- Position the cmdline and popupmenu together
      long_message_to_split = true,  -- Long messages sent to split
      inc_rename = false,            -- Not using inc_rename.nvim
      lsp_doc_border = true,         -- Add border to hover and signature help
    },
    -- Routes for message handling
    routes = {
      {
        filter = {
          event = "notify",
        },
        view = "notify", -- Route notifications to snacks
      },
      {
        -- Show LSP progress in mini view (bottom right corner)
        filter = {
          event = "lsp",
          kind = "progress",
        },
        opts = { skip = false },
        view = "mini",
      },
    },
    -- Views configuration
    views = {
      cmdline_popup = {
        border = {
          style = "rounded",
        },
      },
      hover = {
        border = {
          style = "rounded",
        },
      },
      signature = {
        border = {
          style = "rounded",
        },
      },
    },
  },
}

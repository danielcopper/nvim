-- Blink.cmp: Fast, modern completion engine

return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Keymap presets: 'default' | 'super-tab' | 'enter'
    keymap = { preset = "default" },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    completion = {
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
        },
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    cmdline = {
      sources = {},
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },
  },

  opts_extend = { "sources.default" },
}

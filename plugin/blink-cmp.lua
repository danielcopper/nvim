vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
})

local icons = require("icons")
local borders = require("ui").borders

require("blink.cmp").setup({
  keymap = {
    preset = "super-tab",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-y>"] = { "select_and_accept" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-Space>"] = { "show", "fallback" },
    ["<C-e>"] = { "cancel", "fallback" },
  },

  appearance = {
    nerd_font_variant = "mono",
    kind_icons = icons.lsp.kinds,
  },

  snippets = { preset = "luasnip" },

  completion = {
    list = {
      selection = { preselect = false, auto_insert = true },
    },
    accept = {
      auto_brackets = { enabled = true },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = borders },
    },
    ghost_text = { enabled = false },
    menu = {
      border = borders,
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
        },
      },
    },
  },

  signature = {
    enabled = false, -- noice handles signature help
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" },
})

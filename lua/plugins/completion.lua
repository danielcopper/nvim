local helpers = require("config.theme.helpers")
local icons = require("config.theme.icons")

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet engine
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },

    -- Completion sources
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    -- Autopairs integration
    "windwp/nvim-autopairs",
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Autopairs integration
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered({
          border = helpers.get_border() == "none" and "single" or helpers.get_border(),
          winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
          scrollbar = false,
          col_offset = -3,
          side_padding = 1,
        }),
        documentation = cmp.config.window.bordered({
          border = helpers.get_border() == "none" and "single" or helpers.get_border(),
          winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
        }),
      },

      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          local kind = item.kind

          -- Icon on the left with colored highlight
          item.kind = "" .. (icons.lsp.kinds[kind] or "") .. ""
          item.kind_hl_group = "CmpItemKind" .. kind

          -- Add horizontal padding to suggestion text
          item.abbr = " " .. item.abbr .. " "

          -- Type name on the right with matching color and padding
          item.menu = kind .. " "
          item.menu_hl_group = "CmpItemKind" .. kind

          return item
        end,
      },

      completion = {
        completeopt = "menu,menuone",
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        -- Accept completion with Enter or Ctrl+Y
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),

        -- Navigate completion menu
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),

        -- Scroll documentation
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Toggle completion
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),

        -- Snippet navigation
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
      }),

      experimental = {
        ghost_text = false,
      },
    })
  end,
}

---@diagnostic disable: missing-fields
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",             -- the actual snippet engine
      "hrsh7th/cmp-nvim-lsp",         -- completion source for lsp related stuff
      "hrsh7th/cmp-buffer",           -- source for words in buffer
      "hrsh7th/cmp-path",             -- source for path completion
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",     -- for autocompletion
      "rafamadriz/friendly-snippets", -- collection of useful snippets for different languages
      "onsails/lspkind-nvim",         -- change the appearance of the popup
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- load vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        preselect = "item",
        completion = {
          completeopt = "menu,menuone,preview,noselect",
          keyword_length = 2,
        },

        snippet = {
          -- configure how nvim-cmp interacts with the snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
            border = "rounded"
          },
          documentation = {
            border = "rounded",
          },
        },

        formatting = {
          fields = { "kind", "abbr", "menu" },
          -- TODO: Maybe extend this to also use own icons like shown here: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
          -- and add min_width
          -- adds vscode like indicators in the suggestion list
          format = function(entry, vim_item)
            local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),        -- jump to next suggestion
          ["<C-k>"] = cmp.mapping.select_prev_item(),        -- jump to previous suggestion
          ["<C-f>"] = cmp.mapping.scroll_docs(4),            -- scroll through the hover documentation down
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),           -- scroll through the hover documentation up
          ["<C-Space>"] = cmp.mapping.complete(),            -- show completion suggestions
          ["<C-c>"] = cmp.mapping.abort(),                   -- close completion suggestions
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- apply suggestion (autoselect top suggestion)
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- the sources for autocompletion, the order is represented in the suggestions
        sources = cmp.config.sources({
          { name = "nvim_lua", max_item_count = 30 }, -- nvim_lua automatically handles the enabling in lua files only
          { name = "nvim_lsp", max_item_count = 30 }, -- LSP related snippets
          { name = "luasnip",  max_item_count = 15 }, -- snippets
          {
            name = "buffer",
            max_item_count = 20,
            keyword_length = 2,
            option = {
              keyword_pattern = [[\k\+]],
              -- Enable completion from all visible buffers
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
          { name = "path", max_item_count = 10 }, -- file system paths
          -- NOTE:Signature help is already enabled but i leave it here for future reference
          -- { name = 'nvim_lsp_signature_help' }
        }),

        -- disable the completion in comment sections
        enabled = function()
          -- disable completion in telescope and other prompts
          local buftype = vim.api.nvim_buf_get_option(0, "buftype")
          if buftype == "prompt" then return false end

          -- disable completion in comments
          local context = require("cmp.config.context")
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,

        performance = {
          max_view_entries = 30,
        },

        experimental = {
          native_menu = false,
          ghost_text = true,
        },
      })
    end,
  },
}

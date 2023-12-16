return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",             -- the snippet engine
      "hrsh7th/cmp-nvim-lsp",         -- completion source for lsp related stuff
      "hrsh7th/cmp-buffer",           -- source for words in buffer
      "hrsh7th/cmp-path",             -- source for path completion
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",     -- for autocompletion
      "rafamadriz/friendly-snippets", -- collection of useful snippets for different languages
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- load vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      -- TODO: Make these work and add angular as well https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks/angular
      -- whats not working is triggering the snippets with ///. It works if using <C-n> to manually trigger completions.
      -- friendly-snippets - enable standardized comments snippets
      luasnip.filetype_extend("typescript", { "tsdoc" })
      luasnip.filetype_extend("javascript", { "jsdoc" })
      luasnip.filetype_extend("lua", { "luadoc" })
      luasnip.filetype_extend("cs", { "csharpdoc" })

      cmp.setup({
        preselect = "item",

        completion = {
          completeopt = "menu,menuone,noinsert",
          keyword_length = 2,
        },

        snippet = {
          -- configure how nvim-cmp interacts with the snippet engine
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            border = vim.copper_config.borders
          },
          documentation = {
            border = vim.copper_config.borders,
          },
        },

        formatting = {
          format = function(_, item)
            local icons = require("copper.config.icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),      -- jump to next suggestion
          ["<C-k>"] = cmp.mapping.select_prev_item(),      -- jump to previous suggestion
          ["<C-f>"] = cmp.mapping.scroll_docs(4),          -- scroll through the hover documentation down
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),         -- scroll through the hover documentation up
          ["<C-Space>"] = cmp.mapping.complete(),          -- show completion suggestions
          ["<C-c>"] = cmp.mapping.abort(),                 -- close completion suggestions
          ["<C-e>"] = cmp.mapping.abort(),                 -- close completion suggestions
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- apply suggestion (autoselect top suggestion)
          ["<tab>"] = cmp.mapping(function(fallback) if luasnip.jumpable(1) then luasnip.jump(1) else fallback() end end,
            { "i", "s" }),
          ["<s-tab>"] = cmp.mapping(
            function(fallback) if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end end, { "i" }),
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

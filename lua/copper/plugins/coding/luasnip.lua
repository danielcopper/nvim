return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      local luasnip = require("luasnip")

      luasnip.loaders.from_vscode.lazy_load()

      -- TODO: Make these work and add angular as well https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks/angular
      -- whats not working is triggering the snippets with ///. It works if using <C-n> to manually trigger completions.
      -- friendly-snippets - enable standardized comments snippets
      luasnip.filetype_extend("typescript", { "tsdoc" })
      luasnip.filetype_extend("javascript", { "jsdoc" })
      luasnip.filetype_extend("lua", { "luadoc" })
      luasnip.filetype_extend("cs", { "csharpdoc" })

      luasnip.setup(opts)
    end,
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    }
  }
}

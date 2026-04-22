vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") },
})

require("luasnip.loaders.from_vscode").lazy_load()

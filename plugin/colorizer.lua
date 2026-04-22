vim.pack.add({ "https://github.com/NvChad/nvim-colorizer.lua" })

require("colorizer").setup({
  filetypes = { "*" },
  user_default_options = {
    RRGGBBAA = true,
    tailwind = true,
    sass = { enable = true, parsers = { "css" } },
  },
})

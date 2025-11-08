return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RRGGBBAA = true,
      tailwind = true,
      sass = { enable = true, parsers = { "css" } },
    },
  },
}

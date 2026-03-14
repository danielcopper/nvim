-- Indent-blankline: Show indent guides

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify" },
    },
  },
}

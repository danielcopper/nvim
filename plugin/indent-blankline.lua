vim.pack.add({ "https://github.com/lukas-reineke/indent-blankline.nvim" })

vim.api.nvim_set_hl(0, "IblIndent", { fg = "#313244", nocombine = true })

require("ibl").setup({
  indent = {
    char = "▏",
    highlight = "IblIndent",
  },
  scope = {
    enabled = false, -- mini.indentscope handles animated scope
  },
  exclude = {
    filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify" },
    buftypes = { "terminal" },
  },
})

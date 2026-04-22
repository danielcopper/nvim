vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

require("nvim-autopairs").setup({
  check_ts = true,
  ts_config = {
    lua = { "string" },
  },
  disable_filetype = { "TelescopePrompt", "vim" },
})

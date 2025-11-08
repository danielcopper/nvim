return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string" },
    },
    disable_filetype = { "TelescopePrompt", "vim" },
  },
}

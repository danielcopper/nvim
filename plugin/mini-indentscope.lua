vim.pack.add({ "https://github.com/echasnovski/mini.indentscope" })

require("mini.indentscope").setup({
  symbol = "▏",
  options = {
    try_as_border = true,
  },
  draw = {
    delay = 50,
    animation = function() return 20 end,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

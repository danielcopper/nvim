-- Mini.indentscope: Animated scope line

return {
  "echasnovski/mini.indentscope",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    symbol = "▏",
    options = {
      try_as_border = true,
    },
    draw = {
      delay = 50,
      animation = function()
        return 20 -- ms per step
      end,
    },
  },
  init = function()
    -- Disable for certain filetypes
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
  end,
}

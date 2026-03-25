-- Indent-blankline: Show indent guides
-- Scope highlighting handled by mini.indentscope

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      char = "▏",
      highlight = "IblIndent",
    },
    scope = {
      enabled = false, -- Using mini.indentscope for animated scope
    },
    exclude = {
      filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify" },
      buftypes = { "terminal" },
    },
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#313244", nocombine = true })
    require("ibl").setup(opts)
  end,
}

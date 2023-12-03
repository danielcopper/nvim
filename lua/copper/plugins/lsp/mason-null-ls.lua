return {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("copper.plugins.lsp.null-ls") -- require your null-ls config here (example below)
    require("mason-null-ls").setup({
      ensure_installed =
      {
        "prettier",
        "eslint_d"
      },
      automatic_installation = true,
    })
  end,
}

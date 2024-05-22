-- Garbage collector that stops inactive LSP clients to free RAM
return {
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    grace_period = 60 * 15,
    excluded_lsp_clients = { "omnisharp" },
    notifications = true
  }
}

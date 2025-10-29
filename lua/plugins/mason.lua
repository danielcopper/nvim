-- Mason: Portable package manager for LSP servers, DAP servers, linters, and formatters

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  },
  build = ":MasonUpdate",
  opts = {
    -- Add custom registry for roslyn
    registries = {
      "github:mason-org/mason-registry",
      "github:crashdummyy/mason-registry",
    },
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}

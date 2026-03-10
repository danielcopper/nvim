-- Mason: Portable package manager for LSP servers, DAP servers, linters, and formatters

local icons = require("config.icons")

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  },
  build = ":MasonUpdate",
  opts = {
    ui = {
      icons = {
        package_installed = icons.ui.check,
        package_pending = icons.ui.spinner,
        package_uninstalled = icons.ui.close,
      },
    },
    registries = {
      "github:mason-org/mason-registry",
      "github:crashdummyy/mason-registry",
    },
  },
}

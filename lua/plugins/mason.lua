-- Mason: Portable package manager for LSP servers, DAP servers, linters, and formatters

local helpers = require("config.theme.helpers")
local icons = require("config.theme.icons")

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  },
  build = ":MasonUpdate",
  opts = {
    ui = {
      border = helpers.get_border(),
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

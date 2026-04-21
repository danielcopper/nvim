local icons = require("icons")
local borders = require("ui").borders

require("mason").setup({
  ui = {
    border = borders,
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
})

vim.keymap.set("n", "<leader>tm", "<cmd>Mason<cr>", { desc = "Mason" })

-- Java: Simple jdtls setup via lspconfig
-- jdtls is installed via Mason (see mason-packages.lua)

return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  config = function()
    -- nvim-jdtls will be configured via ftplugin/java.lua
  end,
}

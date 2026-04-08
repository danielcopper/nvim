-- Java: jdtls setup via nvim-jdtls
-- jdtls is installed via Mason (see mason-packages.lua)

return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    -- nvim-jdtls will be configured via ftplugin/java.lua
  end,
}

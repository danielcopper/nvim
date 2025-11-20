-- LSP: Language Server Protocol configuration using Neovim 0.11 native APIs

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "b0o/schemastore.nvim",
  },

  config = function()
    local icons = require("config.theme.icons")
    local helpers = require("config.theme.helpers")

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
        },
      },
      float = {
        border = helpers.get_border(),
        source = true,
      },
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      virtual_text = false,
      virtual_lines = {
        current_line = true,
      },
    })

    -- Setup mason-lspconfig
    -- This automatically enables LSP servers installed via mason-packages.lua
    require("mason-lspconfig").setup({
      automatic_enable = true, -- Automatically calls vim.lsp.enable() for installed servers
    })

    -- Load server configurations
    local servers_module = require("plugins.lsp.servers")
    local servers = servers_module.get_servers()

    -- Configure each server using Neovim 0.11 native API
    for server, config in pairs(servers) do
      vim.lsp.config(server, config)
    end

    -- Enable all configured servers
    vim.lsp.enable(vim.tbl_keys(servers))

    -- Setup LSP keymaps
    require("plugins.lsp.keymaps").setup()
  end,
}

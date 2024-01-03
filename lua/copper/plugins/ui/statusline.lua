local icons = require("copper.config.icons")

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local lazy_status = require("lazy.status")
      vim.api.nvim_set_hl(0, 'LspClientAttached', { fg = '#b4befe' })

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = vim.copper_config.colorscheme,
          globalstatus = true,
          disabled_filetypes = { statusline = { "lazy", "alpha", "starter" } },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              icon = icons.ui.Vim,
              separator = { left = "", right = "" },
            },
          },
          lualine_b = { "branch" },
          -- lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1,
                right = 0,
              },
            },
            {
              "filename",
              path = 1,
              symbols = { modified = icons.ui.ModifiedFile, readonly = "", unnamed = "" },
            },
            {
              "diagnostics",
              symbols = {
                Error = icons.diagnostics.Error,
                Warn = icons.diagnostics.Warning,
                Hint = icons.diagnostics.Hint,
                Info = icons.diagnostics.Information,
              },
            },
          },
          lualine_x = {
            {
              function() return icons.dap.DapSymbol .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            },
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            },
            {
              lazy_status.updates,
              cond = lazy_status.has_updates,
            },
            {
              "diff",
              symbols = {
                added = icons.git.Added,
                modified = icons.git.Modified,
                removed = icons.git.Removed,
              },
            },
            {
              function()
                local active_clients = vim.lsp.get_active_clients()
                if #active_clients == 0 then return "" end

                local client_names = {}

                for _, client in pairs(active_clients) do
                  -- Check if the client is attached to the current buffer and highlight if so
                  local highlight = vim.lsp.buf_is_attached(0, client.id) and "%#LspClientAttached#" or ""
                  table.insert(client_names, highlight .. client.name .. "%*") -- Reset highlight after the name
                end

                return table.concat(client_names, " ")
              end,
            },
            { "encoding" },
            { "fileformat" },
          },
          lualine_y = {
            { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              function()
                return icons.ui.Time .. os.date("%R")
              end,
            },
          },
        },
      })
    end,
  },
}

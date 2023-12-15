local icons = require("copper.config.icons")

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local lazy_status = require("lazy.status")
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "lazy", "alpha", "starter" } },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              icon = icons.ui.Vim,
              separator = { left = "", right = "" },
              color = {
                fg = "#1e1e2e",
                bg = "#b4befe",
              },
            },
          },
          lualine_b = { "branch" },
          -- lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                Error = icons.diagnostics.Error,
                Warn = icons.diagnostics.Warning,
                Hint = icons.diagnostics.Hint,
                Info = icons.diagnostics.Information,
              },
            },
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
              color = { fg = "#ff9e64" },
            },
            {
              "diff",
              symbols = {
                added = icons.git.Added,
                modified = icons.git.Modified,
                removed = icons.git.Removed,
              },
            },
            { "encoding" },
            { "fileformat" },
          },
          lualine_y = {
            { "progress", separator = " ",                   padding = { left = 1, right = 0 },           color = { fg = "#1e1e2e", bg = "#eba0ac", }, },
            { "location", padding = { left = 0, right = 1 }, color = { fg = "#1e1e2e", bg = "#eba0ac", }, },
          },
          lualine_z = {
            {
              function()
                return icons.ui.Time .. os.date("%R")
              end,
              color = { fg = "#1e1e2e", bg = "#f2cdcd", },
            },
          },
        },
        -- show a simplified lualine for these
        -- extensions = { "neo-tree", "nvim-tree", "lazy" },
      })
    end,
  },
}

-- Lualine: Statusline

local icons = require("config.icons")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = "",
      disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
    },
    sections = {
      lualine_a = {
        { "mode", icon = icons.ui.nvim },
      },
      lualine_b = {
        {
          function()
            if vim.fn.bufname() == "" then return "" end
            local devicons = require("nvim-web-devicons")
            local icon = devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
            return icon or ""
          end,
          separator = "",
          padding = { left = 2, right = 0 },
        },
        { "filename", path = 0, symbols = { modified = "", readonly = icons.ui.readonly, unnamed = icons.ui.unknown_file } },
      },
      lualine_c = {
        {
          "branch",
          icon = "",
          fmt = function(branch)
            if branch == "" then return "" end
            local git_path = vim.fn.getcwd() .. "/.git"
            local is_wt = vim.fn.isdirectory(git_path) == 0 and vim.fn.filereadable(git_path) == 1
            local icon = is_wt and icons.git.worktree or icons.git.branch
            return icon .. " " .. branch
          end,
        },
        { "diff", symbols = { added = icons.git.add, modified = icons.git.change, removed = icons.git.delete } },
      },
      lualine_x = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.error,
            warn = icons.diagnostics.warn,
            info = icons.diagnostics.info,
            hint = icons.diagnostics.hint,
          },
        },
        {
          function()
            return string.format("Ln %d, Col %d", vim.fn.line("."), vim.fn.col("."))
          end,
        },
        {
          function()
            local clients = vim.lsp.get_clients({ buffer = 0 })
            if next(clients) == nil then return icons.ui.lsp .. " --" end
            local names = {}
            for _, client in pairs(clients) do
              table.insert(names, client.name)
            end
            if vim.o.columns > 100 then
              return icons.ui.lsp .. " " .. table.concat(names, " | ")
            else
              return icons.ui.lsp .. " LSP"
            end
          end,
          color = function()
            local clients = vim.lsp.get_clients({ buffer = 0 })
            if next(clients) then
              return { fg = "#a6e3a1" }
            end
            return { fg = "#6c7086" }
          end,
        },
        { "encoding", icons_enabled = false },
        {
          "fileformat",
          icons_enabled = false,
          fmt = function(str)
            if str == "unix" then return "" end
            local map = { dos = "CRLF", mac = "CR" }
            return map[str] or str
          end,
          cond = function()
            return vim.bo.fileformat ~= "unix"
          end,
        },
        { "filetype", icon = { align = "left" } },
      },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "neo-tree", "lazy", "trouble", "mason" },
  },
}

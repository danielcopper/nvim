-- Lualine: Statusline

local icons = require("config.theme.icons")
local helpers = require("config.theme.helpers")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = function()
    local palette = helpers.get_palette()

    -- Custom theme with uniform backgrounds (only mode section colored)
    local function get_theme()
      if palette then
        local bg = palette.mantle
        local fg = palette.text

        return {
          normal = {
            a = { bg = palette.blue, fg = palette.base, gui = "bold" },
            b = { bg = bg, fg = fg },
            c = { bg = bg, fg = fg },
            x = { bg = bg, fg = fg },
            y = { bg = bg, fg = fg },
            z = { bg = bg, fg = fg },
          },
          insert = {
            a = { bg = palette.green, fg = palette.base, gui = "bold" },
          },
          visual = {
            a = { bg = palette.mauve, fg = palette.base, gui = "bold" },
          },
          replace = {
            a = { bg = palette.red, fg = palette.base, gui = "bold" },
          },
          command = {
            a = { bg = palette.peach, fg = palette.base, gui = "bold" },
          },
          inactive = {
            a = { bg = bg, fg = palette.overlay0 },
            b = { bg = bg, fg = palette.overlay0 },
            c = { bg = bg, fg = palette.overlay0 },
          },
        }
      else
        return "auto"
      end
    end

    -- Repository-wide git status (global across all files)
    local function git_repo_status()
      local handle = io.popen("git -C " .. vim.fn.getcwd() .. " diff --shortstat 2>/dev/null")
      if not handle then
        return ""
      end

      local result = handle:read("*a")
      handle:close()

      if result == "" then
        return ""
      end

      -- Parse: "X files changed, Y insertions(+), Z deletions(-)"
      local files_changed = result:match("(%d+) file") or "0"
      local added = result:match("(%d+) insertion") or "0"
      local removed = result:match("(%d+) deletion") or "0"

      -- Use lualine's diff highlight groups for consistent coloring
      local parts = {}
      if tonumber(added) > 0 then
        table.insert(parts, "%#lualine_c_diff_added_normal#" .. icons.git.add .. added .. "%*")
      end
      if tonumber(files_changed) > 0 then
        table.insert(parts, "%#lualine_c_diff_modified_normal#" .. icons.git.change .. files_changed .. "%*")
      end
      if tonumber(removed) > 0 then
        table.insert(parts, "%#lualine_c_diff_removed_normal#" .. icons.git.delete .. removed .. "%*")
      end

      return #parts > 0 and table.concat(parts, " ") .. " |" or ""
    end

    return {
      options = {
        theme = get_theme(),
        globalstatus = true,
        component_separators = { left = " ", right = "|" },
        section_separators = { left = " ", right = " " },
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icon = icons.ui.nvim,
          },
        },
        lualine_b = {
          {
            "branch",
            icon = icons.git.branch,
          },
          {
            git_repo_status,
            cond = function()
              return vim.fn.isdirectory(".git") == 1
            end,
          },
        },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 },
          {
            "diff",
            symbols = {
              added = icons.git.add,
              modified = icons.git.change,
              removed = icons.git.delete,
            },
          },
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
              local buf_clients = vim.lsp.get_clients({ buffer = 0 })
              if next(buf_clients) == nil then
                return ""
              end

              local client_names = {}
              for _, client in pairs(buf_clients) do
                table.insert(client_names, client.name)
              end

              if vim.o.columns > 100 then
                return icons.ui.lsp .. " " .. table.concat(client_names, " | ")
              else
                return icons.ui.lsp .. " LSP"
              end
            end,
            color = palette and { fg = palette.sapphire, gui = "bold" } or { gui = "bold" },
          },
          {
            "filetype",
            icon = { align = "right" },
            color = palette and { fg = palette.mauve } or nil,
          },
          {
            "fileformat",
            icons_enabled = true,
            color = palette and { fg = palette.green } or nil,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy", "trouble", "mason" },
    }
  end,
}

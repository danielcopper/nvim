-- Lualine: Statusline

local icons = require("config.theme.icons")
local helpers = require("config.theme.helpers")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = function()
    local palette = helpers.get_palette()

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
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = "",
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
            function()
              -- Don't show icon for unnamed buffers
              if vim.fn.bufname() == "" then
                return ""
              end

              local devicons = require("nvim-web-devicons")
              local ft = vim.bo.filetype
              local icon = devicons.get_icon_by_filetype(ft, { default = true })
              return icon or ""
            end,
            separator = "",
            padding = { left = 2, right = 0 },
            color = palette and { fg = palette.text } or nil,
          },
          { "filename", path = 0, symbols = { modified = "", readonly = icons.ui.readonly, unnamed = icons.ui.unknown_file }, color = palette and { fg = palette.text } or nil },
          -- {
          --   git_repo_status,
          --   cond = function()
          --     return vim.fn.isdirectory(".git") == 1
          --   end,
          -- },
        },
        lualine_c = {
          {
            "branch",
            icon = icons.git.branch,
          },
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
              if not rawget(vim, "lsp") then
                return ""
              end

              local err = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
              local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
              local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
              local hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

              if err + warn + info + hint == 0 then
                return ""
              end

              return "|"
            end,
            color = function()
              if not palette then
                return nil
              end

              local err = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
              local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
              local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
              local hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

              -- Priority: error > warn > info > hint
              if err > 0 then
                return { fg = palette.red }
              elseif warn > 0 then
                return { fg = palette.yellow }
              elseif info > 0 then
                return { fg = palette.sky }
              elseif hint > 0 then
                return { fg = palette.teal }
              end

              return nil
            end,
            padding = { left = 1, right = 1 },
          },
          {
            function()
              local line = vim.fn.line(".")
              local col = vim.fn.col(".")
              return string.format("Ln %d, Col %d", line, col)
            end,
            color = palette and { fg = palette.overlay1 } or nil,
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
            color = palette and { fg = palette.green } or nil,
          },
          {
            "encoding",
            icons_enabled = false,
            color = palette and { fg = palette.mauve } or nil,
          },
          {
            "filetype",
            icon = { align = "left" },
            color = palette and { fg = palette.blue } or nil,
          },
          {
            function()
              local cwd = vim.fn.getcwd()
              return icons.ui.folder .. " " .. vim.fn.fnamemodify(cwd, ":t")
            end,
            color = palette and { bg = palette.surface0, fg = palette.red } or nil,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy", "trouble", "mason" },
    }
  end,
}

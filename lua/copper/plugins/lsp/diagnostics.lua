return {
  -- More detailed lsp diagnostics info
  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "BufEnter" },
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
      })

      -- Disable the plugin in specified filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lazy",
        callback = function()
          local previous = not require("lsp_lines").toggle()
          if not previous then
            require("lsp_lines").toggle()
          end
        end,
      })

      require("lsp_lines").setup()
    end,
  },
}

-- local function toggle_lsp_lines_based_on_diagnostics()
--   local diagnostics = vim.diagnostic.get(0)
--   local diagnostic_counts = {}
--
--   for _, diag in ipairs(diagnostics) do
--     local line = diag.lnum
--     diagnostic_counts[line] = (diagnostic_counts[line] or 0) + 1
--   end
--
--   local lsp_lines_active = require("lsp_lines").is_enabled()
--   for _, count in pairs(diagnostic_counts) do
--     if count > 1 and not lsp_lines_active then
--       require("lsp_lines").toggle()
--       return
--     elseif count <= 1 and lsp_lines_active then
--       require("lsp_lines").toggle()
--       return
--     end
--   end
-- end
--
-- -- Your existing plugin setup
-- return {
--   -- More detailed lsp diagnostics info
--   {
--     url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
--     event = { "BufEnter" },
--     config = function()
--       vim.diagnostic.config({
--         virtual_text = false,
--       })
--
--       vim.api.nvim_create_autocmd("FileType", {
--         pattern = "lazy",
--         callback = function()
--           -- Your existing logic to disable lsp_lines for specific filetypes
--         end,
--       })
--
--       require("lsp_lines").setup()
--
--       -- Add an autocommand that triggers when diagnostics change
--       vim.api.nvim_create_autocmd({"DiagnosticChanged", "BufEnter"}, {
--         callback = toggle_lsp_lines_based_on_diagnostics,
--       })
--     end,
--   },
-- }
--

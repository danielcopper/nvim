-- LSP Keymaps
-- Attached via LspAttach autocmd when LSP client attaches to buffer

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("config_lsp_attach", { clear = true }),
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      -- Helper function to set keymaps
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Telescope integrations (better UI for references, definitions, etc.)
      if pcall(require, "telescope.builtin") then
        map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
        map("n", "gr", "<cmd>Telescope lsp_references<cr>", "Show references")
        map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Go to implementation")
        map("n", "gD", "<cmd>Telescope lsp_type_definitions<cr>", "Go to type definition")
      end

      -- Additional useful keymaps
      map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP Info")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
      map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
      map("n", "<leader>vd", vim.diagnostic.open_float, "Show line diagnostics")

      -- Inlay hints (if supported)
      if client and client.supports_method("textDocument/inlayHint") then
        map("n", "<leader>uh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, "Toggle inlay hints")
      end
    end,
  })
end

return M

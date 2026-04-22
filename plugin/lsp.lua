vim.pack.add({ "https://github.com/b0o/schemastore.nvim" })

local icons = require("icons")
local borders = require("ui").borders

-- Diagnostics
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
    source = true,
    border = borders,
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  virtual_text = false,
  virtual_lines = {
    current_line = true,
  },
})

-- Default capabilities for all LSP servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }

vim.lsp.config("*", { capabilities = capabilities })

-- Enable LSP servers (configs auto-discovered from lsp/ directory)
vim.lsp.enable({
  "angularls",
  "azure_pipelines_ls",
  "basedpyright",
  "bashls",
  "cssls",
  "dockerls",
  "emmet_language_server",
  "eslint",
  "html",
  "jsonls",
  "lemminx",
  "lua_ls",
  "markdown_oxide",
  "powershell_es",
  "ts_ls",
  "yamlls",
})

local lsp_state = require("lsp_state")

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    if ev.data.params.value.kind == "end" then
      lsp_state.busy[ev.data.client_id] = nil
    else
      lsp_state.busy[ev.data.client_id] = true
    end
    vim.cmd.redrawstatus()
  end,
})

-- Clear busy state if a client detaches/crashes (prevents stale spinner)
vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    lsp_state.busy[args.data.client_id] = nil
    vim.cmd.redrawstatus()
  end,
})

-- LSP keymaps (buffer-local, only active after LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("config_lsp_attach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

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

    if client and client:supports_method("textDocument/codeAction", { bufnr = bufnr }) then
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    end
    if client and client:supports_method("textDocument/rename", { bufnr = bufnr }) then
      map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    end
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")

    -- Inlay hints (if supported)
    if client and client:supports_method("textDocument/inlayHint", { bufnr = bufnr }) then
      map("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
      end, "Toggle inlay hints")
    end
  end,
})

vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, { desc = "Show LSP health (alias for :checkhealth vim.lsp)" })

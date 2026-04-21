-- Shared LSP progress state (client_id -> true while busy).
-- Populated by plugin/lsp.lua (LspProgress/LspDetach autocmds),
-- consumed by lualine for the spinner.
local M = {}
M.busy = {}
return M

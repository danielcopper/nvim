local M = {}

--- Set keybindings for an LSP client buffer.
-- This function iterates over a table of keybindings and applies them
-- to the specified buffer. Each keybinding is a table containing the mode,
-- keys, function to execute, and a description.
-- @param bufnr number The buffer number to which the keybindings should be applied.
-- @param keymap_table table A table of keybindings. Each keybinding should be a table with the following structure: { mode, keys, func, desc }.
-- TODO: Fix
function M.set_keybinds(bufnr, keymap_table)
  local set = vim.keymap.set
  for _, keymap in ipairs(keymap_table) do
    local mode, keys, func, desc = unpack(keymap)
    print("Setting keybind:", keys, "for buffer", bufnr) -- Debug print

    set(mode, keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
  end
end

return M

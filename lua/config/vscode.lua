-- VSCode-specific configuration and keybindings
-- Maps your existing keybindings to VSCode command equivalents

local vscode = require("vscode")

-- Helper for calling VSCode commands
local function call(cmd)
  return function() vscode.call(cmd) end
end

local keymap = vim.keymap.set

--------------------------------------------------
-- File Navigation (matching telescope.lua)
--------------------------------------------------
keymap("n", "<leader>ff", call("workbench.action.quickOpen"), { desc = "Find files" })
keymap("n", "<leader>fr", call("workbench.action.openRecent"), { desc = "Old/recent files" })
keymap("n", "<leader>fo", call("workbench.action.showAllEditors"), { desc = "Buffers" })
keymap("n", "<leader>fs", call("workbench.action.findInFiles"), { desc = "Search (grep)" })
keymap("n", "<leader>fw", call("editor.action.addSelectionToNextFindMatch"), { desc = "Word under cursor" })
keymap("n", "<leader>fh", call("workbench.action.showAllSymbols"), { desc = "Help/symbols" })
keymap("n", "<leader>fk", call("workbench.action.openGlobalKeybindings"), { desc = "Keymaps" })
keymap("n", "<leader>fc", call("workbench.action.showCommands"), { desc = "Commands" })
keymap("n", "<leader>fd", call("workbench.actions.view.problems"), { desc = "Diagnostics" })

--------------------------------------------------
-- File Explorer (matching neo-tree.lua)
--------------------------------------------------
keymap("n", "<leader>te", call("workbench.action.toggleSidebarVisibility"), { desc = "Toggle file explorer" })
keymap("n", "<leader>fe", call("workbench.view.explorer"), { desc = "Focus file explorer" })

--------------------------------------------------
-- LSP Actions (matching lsp/keymaps.lua)
--------------------------------------------------
keymap("n", "gd", call("editor.action.revealDefinition"), { desc = "Go to definition" })
keymap("n", "gr", call("editor.action.goToReferences"), { desc = "Show references" })
keymap("n", "gi", call("editor.action.goToImplementation"), { desc = "Go to implementation" })
keymap("n", "gD", call("editor.action.goToTypeDefinition"), { desc = "Go to type definition" })
keymap("n", "<leader>cl", call("workbench.action.showAllSymbols"), { desc = "LSP Info (symbols)" })
keymap("n", "<leader>ca", call("editor.action.quickFix"), { desc = "Code action" })
keymap("n", "<leader>cr", call("editor.action.rename"), { desc = "Rename symbol" })
keymap("n", "<leader>vd", call("editor.action.showHover"), { desc = "Show line diagnostics" })

-- Diagnostics navigation
keymap("n", "[d", call("editor.action.marker.prev"), { desc = "Previous diagnostic" })
keymap("n", "]d", call("editor.action.marker.next"), { desc = "Next diagnostic" })

--------------------------------------------------
-- Buffer/Editor Management (matching keymaps.lua)
--------------------------------------------------
keymap("n", "<leader>w", call("workbench.action.files.save"), { desc = "Save file" })
keymap("n", "<leader>q", call("workbench.action.closeActiveEditor"), { desc = "Quit/close" })
keymap("n", "<leader>bd", call("workbench.action.closeActiveEditor"), { desc = "Close buffer" })
keymap("n", "H", call("workbench.action.previousEditor"), { desc = "Previous buffer" })
keymap("n", "L", call("workbench.action.nextEditor"), { desc = "Next buffer" })
keymap("n", "[b", call("workbench.action.previousEditor"), { desc = "Previous buffer" })
keymap("n", "]b", call("workbench.action.nextEditor"), { desc = "Next buffer" })

-- Quick buffer access with Alt+number
for i = 1, 9 do
  keymap("n", "<A-" .. i .. ">", call("workbench.action.openEditorAtIndex" .. i), { desc = "Go to buffer " .. i })
end

--------------------------------------------------
-- Window Navigation (matching keymaps.lua)
--------------------------------------------------
keymap("n", "<C-h>", call("workbench.action.focusLeftGroup"), { desc = "Move to left window" })
keymap("n", "<C-j>", call("workbench.action.focusBelowGroup"), { desc = "Move to bottom window" })
keymap("n", "<C-k>", call("workbench.action.focusAboveGroup"), { desc = "Move to top window" })
keymap("n", "<C-l>", call("workbench.action.focusRightGroup"), { desc = "Move to right window" })

--------------------------------------------------
-- Git
--------------------------------------------------
keymap("n", "<leader>gg", call("workbench.view.scm"), { desc = "Source control" })

--------------------------------------------------
-- Terminal
--------------------------------------------------
keymap("n", "<C-/>", call("workbench.action.terminal.toggleTerminal"), { desc = "Toggle terminal" })

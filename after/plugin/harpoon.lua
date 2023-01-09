local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- some remaps for harpoons navigation
-- add a file to harpoon
vim.keymap.set("n", "<leader>a", mark.add_file)
-- toggle harpoon quick menu
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

-- keymaps for switching between the first 4 files
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

local builtin = require('telescope.builtin')

-- search project files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

-- ctrl p should search git files (not working right now -> do some research)
vim.keymap.set('n', 'C-p', builtin.git_files, {})

-- This searches files that contain a string -> research grep on windows
-- FIXED -> install grep with choco
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)

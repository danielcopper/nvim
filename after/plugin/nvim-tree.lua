-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
    git = {
        ignore = false,
      },
    view = {
        width = 35,
    },
    renderer = {
        full_name = true,
    }
  })

vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>er", ":NvimTreeRefresh<CR>")

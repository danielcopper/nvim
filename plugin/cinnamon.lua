vim.pack.add({ "https://github.com/declancm/cinnamon.nvim" })

local cinnamon = require("cinnamon")

cinnamon.setup({
  options = {
    delay = 3,
    max_delta = {
      time = 100,
    },
  },
  keymaps = {
    basic = false,
    extra = false,
  },
})

vim.keymap.set("n", "<C-d>", function() cinnamon.scroll("<C-d>zz") end, { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", function() cinnamon.scroll("<C-u>zz") end, { desc = "Scroll up and center" })
vim.keymap.set("n", "<C-f>", function() cinnamon.scroll("<C-f>zz") end, { desc = "Page down and center" })
vim.keymap.set("n", "<C-b>", function() cinnamon.scroll("<C-b>zz") end, { desc = "Page up and center" })

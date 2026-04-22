vim.pack.add({ "https://github.com/RRethy/vim-illuminate" })

require("illuminate").configure({
  delay = 200,
  large_file_cutoff = 2000,
  filetypes_denylist = {
    "neo-tree",
    "Trouble",
    "help",
    "lazy",
    "mason",
    "notify",
    "DressingInput",
  },
})

vim.keymap.set("n", "]]", function() require("illuminate").goto_next_reference(false) end, { desc = "Next reference" })
vim.keymap.set("n", "[[", function() require("illuminate").goto_prev_reference(false) end, { desc = "Prev reference" })

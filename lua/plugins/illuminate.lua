-- Vim-illuminate: Highlight word under cursor

return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next reference" },
    { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev reference" },
  },
  opts = {
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
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}

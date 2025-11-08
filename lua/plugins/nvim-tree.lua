return {
  "nvim-tree/nvim-tree.lua",
  enabled = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<leader>te", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    { "<leader>fe", "<cmd>NvimTreeFocus<cr>",  desc = "Focus file explorer" },
  },
  opts = {}
}

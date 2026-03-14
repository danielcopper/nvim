-- Octo: GitHub PR and issue management

return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "List issues" },
    { "<leader>gI", "<cmd>Octo issue search<cr>", desc = "Search issues" },
    { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs" },
    { "<leader>gP", "<cmd>Octo pr search<cr>", desc = "Search PRs" },
  },
  opts = {
    enable_builtin = true,
    default_merge_method = "squash",
    picker = "telescope",
  },
}

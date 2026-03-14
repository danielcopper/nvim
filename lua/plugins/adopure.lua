-- Adopure: Azure DevOps PR management

return {
  "Willem-J-an/adopure.nvim",
  cmd = "AdoPure",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim",
  },
  keys = {
    -- Load
    { "<leader>alc", "<cmd>AdoPure load context<cr>", desc = "Load PR context" },
    { "<leader>alt", "<cmd>AdoPure load threads<cr>", desc = "Load threads" },
    -- Open
    { "<leader>aoq", "<cmd>AdoPure open quickfix<cr>", desc = "Open quickfix" },
    { "<leader>aot", "<cmd>AdoPure open thread_picker<cr>", desc = "Thread picker" },
    { "<leader>aon", "<cmd>AdoPure open new_thread<cr>", desc = "New thread" },
    { "<leader>aoe", "<cmd>AdoPure open existing_thread<cr>", desc = "Open thread" },
    -- Submit
    { "<leader>asc", "<cmd>AdoPure submit comment<cr>", desc = "Submit comment" },
    { "<leader>asv", "<cmd>AdoPure submit vote<cr>", desc = "Submit vote" },
    { "<leader>ast", "<cmd>AdoPure submit thread_status<cr>", desc = "Submit status" },
  },
}

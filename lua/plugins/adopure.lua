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
    { "<leader>plc", "<cmd>AdoPure load context<cr>", desc = "Load PR context" },
    { "<leader>plt", "<cmd>AdoPure load threads<cr>", desc = "Load threads" },
    -- Open
    { "<leader>poq", "<cmd>AdoPure open quickfix<cr>", desc = "Open quickfix" },
    { "<leader>pot", "<cmd>AdoPure open thread_picker<cr>", desc = "Thread picker" },
    { "<leader>pon", "<cmd>AdoPure open new_thread<cr>", desc = "New thread" },
    { "<leader>poe", "<cmd>AdoPure open existing_thread<cr>", desc = "Open thread" },
    -- Submit
    { "<leader>psc", "<cmd>AdoPure submit comment<cr>", desc = "Submit comment" },
    { "<leader>psv", "<cmd>AdoPure submit vote<cr>", desc = "Submit vote" },
    { "<leader>pst", "<cmd>AdoPure submit thread_status<cr>", desc = "Submit status" },
  },
}

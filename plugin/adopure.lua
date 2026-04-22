vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/Willem-J-an/adopure.nvim",
})

-- adopure.nvim has no setup() call — commands register themselves on :AdoPure.

-- Load
vim.keymap.set("n", "<leader>plc", "<cmd>AdoPure load context<cr>", { desc = "Load PR context" })
vim.keymap.set("n", "<leader>plt", "<cmd>AdoPure load threads<cr>", { desc = "Load threads" })
-- Open
vim.keymap.set("n", "<leader>poq", "<cmd>AdoPure open quickfix<cr>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>pot", "<cmd>AdoPure open thread_picker<cr>", { desc = "Thread picker" })
vim.keymap.set("n", "<leader>pon", "<cmd>AdoPure open new_thread<cr>", { desc = "New thread" })
vim.keymap.set("n", "<leader>poe", "<cmd>AdoPure open existing_thread<cr>", { desc = "Open thread" })
-- Submit
vim.keymap.set("n", "<leader>psc", "<cmd>AdoPure submit comment<cr>", { desc = "Submit comment" })
vim.keymap.set("n", "<leader>psv", "<cmd>AdoPure submit vote<cr>", { desc = "Submit vote" })
vim.keymap.set("n", "<leader>pst", "<cmd>AdoPure submit thread_status<cr>", { desc = "Submit status" })

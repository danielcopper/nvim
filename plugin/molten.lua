vim.pack.add({ { src = "https://github.com/benlubas/molten-nvim", version = vim.version.range("1.x") } })

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true
vim.g.molten_auto_open_output = false
vim.g.molten_output_win_border = { "", "─", "", "" }

vim.keymap.set("n", "<leader>ji", ":MoltenInit<cr>", { desc = "Initialize Molten", silent = true })
vim.keymap.set("n", "<leader>je", ":MoltenEvaluateOperator<cr>", { desc = "Evaluate Operator", silent = true })
vim.keymap.set("n", "<leader>jl", ":MoltenEvaluateLine<cr>", { desc = "Evaluate Line", silent = true })
vim.keymap.set("n", "<leader>jc", ":MoltenReevaluateCell<cr>", { desc = "Re-evaluate Cell", silent = true })
vim.keymap.set("v", "<leader>jr", ":MoltenEvaluateVisual<cr>gv", { desc = "Evaluate Visual", silent = true })
vim.keymap.set("n", "<leader>jo", ":MoltenShowOutput<cr>", { desc = "Show Output", silent = true })
vim.keymap.set("n", "<leader>jh", ":MoltenHideOutput<cr>", { desc = "Hide Output", silent = true })
vim.keymap.set("n", "<leader>jd", ":MoltenDelete<cr>", { desc = "Delete Cell", silent = true })
vim.keymap.set("n", "]j", ":MoltenNext<cr>", { desc = "Next Cell", silent = true })
vim.keymap.set("n", "[j", ":MoltenPrev<cr>", { desc = "Previous Cell", silent = true })
vim.keymap.set("n", "<leader>jx", ":MoltenInterrupt<cr>", { desc = "Interrupt Execution", silent = true })
vim.keymap.set("n", "<leader>jR", ":MoltenRestart!<cr>", { desc = "Restart Kernel", silent = true })

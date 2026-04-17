-- Molten: inline notebook execution with output display (like VSCode/JupyterLab)
-- Requires: Python provider enabled, kitty/wezterm/ghostty terminal for image support

return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  dependencies = {},
  build = ":UpdateRemotePlugins",
  ft = { "python", "jupyter" },

  init = function()
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true

    -- Don't auto-show output for every cell (can be noisy)
    vim.g.molten_auto_open_output = false

    -- Use borders for output windows
    vim.g.molten_output_win_border = { "", "─", "", "" }
  end,

  keys = {
    { "<leader>ji", ":MoltenInit<cr>", desc = "Initialize Molten", silent = true },

    { "<leader>je", ":MoltenEvaluateOperator<cr>", desc = "Evaluate Operator", silent = true },
    { "<leader>jl", ":MoltenEvaluateLine<cr>", desc = "Evaluate Line", silent = true },
    { "<leader>jc", ":MoltenReevaluateCell<cr>", desc = "Re-evaluate Cell", silent = true },
    { "<leader>jr", ":MoltenEvaluateVisual<cr>gv", desc = "Evaluate Visual", mode = "v", silent = true },

    { "<leader>jo", ":MoltenShowOutput<cr>", desc = "Show Output", silent = true },
    { "<leader>jh", ":MoltenHideOutput<cr>", desc = "Hide Output", silent = true },
    { "<leader>jd", ":MoltenDelete<cr>", desc = "Delete Cell", silent = true },

    { "]j", ":MoltenNext<cr>", desc = "Next Cell", silent = true },
    { "[j", ":MoltenPrev<cr>", desc = "Previous Cell", silent = true },

    { "<leader>jx", ":MoltenInterrupt<cr>", desc = "Interrupt Execution", silent = true },
    { "<leader>jR", ":MoltenRestart!<cr>", desc = "Restart Kernel", silent = true },
  },
}

return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      position = "right",
      icons = true,
      use_diagnostic_signs = true,
    },
    keys = {
      { "<leader>to", "<cmd>Trouble<cr>", { desc = "Open Workspace Diagnostics (Trouble)" } },
      { "<leader>tf", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Toggle Document Diagnostics (Trouble)" }, },
      { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Toggle Workspace Diagnostics (Trouble)" }, },
    },
  },
}

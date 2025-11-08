return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    keys = {
      { "<leader>te", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>fe", "<cmd>Neotree focus<cr>",  desc = "Focus file explorer" },
    },
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
      },
    },
    lazy = false, -- neo-tree will lazily load itself
  }
}

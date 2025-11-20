local icons = require("config.theme.icons")

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
      { "<leader>fe", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
    },
    opts = {
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = icons.ui.foldclose,
          expander_expanded = icons.ui.foldopen,
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = icons.ui.folder,
          folder_open = icons.ui.folder_open,
          folder_empty = icons.ui.folder_empty,
          default = icons.ui.file,
        },
        modified = {
          symbol = icons.ui.modified,
        },
        git_status = {
          symbols = {
            added = icons.git.add,
            modified = icons.git.change,
            deleted = icons.git.delete,
            renamed = icons.git.renamed,
            untracked = icons.git.untracked,
            ignored = icons.git.ignored,
            unstaged = icons.git.unstaged,
            staged = icons.git.staged,
            conflict = icons.git.conflict,
          },
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
    },
    lazy = false, -- neo-tree will lazily load itself
  },
}

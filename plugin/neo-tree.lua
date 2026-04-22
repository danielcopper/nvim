vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MunifTanjim/nui.nvim",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})

local icons = require("icons")

require("neo-tree").setup({
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
    hijack_netrw_behavior = "disabled",
    use_libuv_file_watcher = true,
  },
})

vim.keymap.set("n", "<leader>te", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>fe", "<cmd>Neotree focus<cr>", { desc = "Focus file explorer" })

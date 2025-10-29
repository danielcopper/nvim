-- Neo-tree: File explorer with tree view

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>te", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    { "<leader>fe", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,

    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1,
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
      },
      git_status = {
        symbols = {
          added     = "",
          modified  = "",
          deleted   = "",
          renamed   = "",
          untracked = "",
          ignored   = "",
          unstaged  = "",
          staged    = "",
          conflict  = "",
        },
      },
    },

    window = {
      position = "left",
      width = 35,
      mappings = {
        ["<space>"] = "none",
        ["<cr>"] = "open",
        ["l"] = "open",
        ["h"] = "close_node",
        ["v"] = "open_vsplit",
        ["s"] = "open_split",
        ["t"] = "open_tabnew",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["R"] = "refresh",
        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["q"] = "close_window",
        ["?"] = "show_help",
      },
    },

    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      hijack_netrw_behavior = "disabled",
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = true,
        hide_gitignored = false,
        hide_by_name = {
          "node_modules",
          ".git",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
    },
  },
}

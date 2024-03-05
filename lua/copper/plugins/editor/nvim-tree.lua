local icons = require("copper.config.icons")

return {
  "nvim-tree/nvim-tree.lua",
  enabled = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    require("nvim-tree")
  end,
  opts = {
    filters = {
      dotfiles = false,
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    git = {
      enable = true,
      ignore = false,
      show_on_dirs = true,
      show_on_open_dirs = true,
      timeout = 5000,
    },
    view = {
      adaptive_size = false,
      side = "left",
      width = 40,
      preserve_window_proportions = true,
    },
    filesystem_watchers = {
      enable = true,
    },
    renderer = {
      full_name = true,
      highlight_opened_files = "all",
      -- root_folder_label = ':~:s?$?/..?',
      root_folder_label = ":t",
      -- root_folder_label = false,
      indent_width = 2,
      indent_markers = {
        enable = true,
      },
      icons = {
        git_placement = "signcolumn",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = "󰈚",
          symlink = "",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
            arrow_open = "",
            arrow_closed = "",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
      },

    },
    update_focused_file = {
      enable = true,
      update_root = false,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
      change_dir = {
        restrict_above_cwd = false,
      },
    },
  },
  keys = {
    { "<leader>fe", "<Cmd>NvimTreeFocus<CR>",   { desc = "Focus on NvimTree" } },
    { "<leader>te", "<Cmd>NvimTreeToggle<CR>",  { desc = "Toggle NvimTree" } },
    { "<leader>tr", "<Cmd>NvimTreeRefresh<CR>", { desc = "Refresh NvimTree" } },
  },
}

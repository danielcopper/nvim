local icons = require("copper.utils.icons")

return {
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   enabled = true,
  --   branch = "v3.x",
  --   cmd = "Neotree",
  --   keys = {
  --     { "<leader>fe", "<Cmd>Neotree focus<CR>",  { desc = "Focus on Neotree" } },
  --     { "<leader>te", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" } },
  --   },
  --   init = function()
  --     if vim.fn.argc() == 1 then
  --       local stat = vim.loop.fs_stat(vim.fn.argv(0))
  --       if stat and stat.type == "directory" then
  --         require("neo-tree")
  --       end
  --     end
  --   end,
  --   opts = {
  --     sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  --     filesystem = {
  --       filtered_items = {
  --         visible = true, -- when true, they will just be displayed differently than normal items
  --       },
  --       bind_to_cwd = true,
  --       follow_current_file = { enabled = true },
  --       use_libuv_file_watcher = true,
  --     },
  --     window = {
  --       width = 27,
  --       mappings = {
  --         ["<space>"] = "none",
  --       },
  --     },
  --     default_component_configs = {
  --       indent = {
  --         with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
  --         expander_collapsed = "",
  --         expander_expanded = "",
  --         expander_highlight = "NeoTreeExpander",
  --       },
  --     },
  --     git_status = {
  --       symbols = {
  --         -- Change type
  --         added = icons.git.Added,
  --         -- modified = icons.git.Modified,
  --         modified = "IamModified",
  --
  --         deleted = icons.git.Removed, -- this can only be used in the git_status source
  --         renamed = icons.git.Renamed, -- this can only be used in the git_status source
  --         -- Status type
  --         untracked = icons.git.Untracked,
  --         ignored = icons.git.IgnoredAlt,
  --         unstaged = icons.git.Unstaged,
  --         staged = icons.git.Staged,
  --         conflict = icons.git.Conflict,
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("neo-tree").setup(opts)
  --     vim.api.nvim_create_autocmd("TermClose", {
  --       pattern = "*lazygit",
  --       callback = function()
  --         if package.loaded["neo-tree.sources.git_status"] then
  --           require("neo-tree.sources.git_status").refresh()
  --         end
  --       end,
  --     })
  --   end,
  -- },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
    keys = {
      { "<leader>fe", "<Cmd>Neotree focus<CR>",  { desc = "Focus on Neotree" } },
      { "<leader>te", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" } },
    },
    opts = {
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "diagnostics",
        -- "document_symbols",
      },
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
        content_layout = "center",
        tabs_layout = "equal",
        show_separator_on_edge = true,
        sources = {
          { source = "filesystem", display_name = "󰉓" },
          { source = "buffers", display_name = "󰈙" },
          { source = "git_status", display_name = "" },
          -- { source = "document_symbols", display_name = "o" },
          { source = "diagnostics", display_name = "󰒡" },
        },
      },
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          -- expander config, needed for nesting files
          -- with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          -- expander_collapsed = "",
          -- expander_expanded = "",
          -- expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          folder_empty_open = "",
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = " ",
        },
        modified = { symbol = "" },
        git_status = { symbols = icons.git },
        diagnostics = { symbols = icons.diagnostics },
      },
      window = {
        width = 40,
          mappings = {
            -- ["<space>"] = false, -- disable space until we figure out which-key disabling
            ["H"] = "prev_source",
            ["L"] = "next_source",
          },
      },
      filesystem = {
        window = {
          mappings = {
            ["H"] = "navigate_up",
            ["<bs>"] = "toggle_hidden",
            ["."] = "set_root",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["a"] = { "add", config = { show_path = "relative" } }, -- "none", "relative", "absolute"
          },
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },                   -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
      },
      async_directory_scan = "always",
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
          vim.cmd([[set showtabline=0]])
        end
      end
    end,
  },

  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   cmd = "Neotree",
  --   init = function() vim.g.neo_tree_remove_legacy_commands = true end,
  --   opts = function()
  --     return {
  --       auto_clean_after_session_restore = true,
  --       close_if_last_window = false,
  --       buffers = {
  --         show_unloaded = true
  --       },
  --       sources = { "filesystem", "buffers", "git_status" },
  --       source_selector = {
  --         winbar = true,
  --         content_layout = "center",
  --         sources = {
  --           { source = "filesystem", display_name = "󰉓" },
  --           { source = "buffers", display_name = "󰈙" },
  --           { source = "git_status", display_name = "" },
  --           { source = "document_symbols", display_name = "o" },
  --           { source = "diagnostics", display_name = "󰒡" },
  --         },
  --       },
  --       window = {
  --         width = 30,
  --         mappings = {
  --           -- ["<space>"] = false, -- disable space until we figure out which-key disabling
  --           ["H"] = "prev_source",
  --           ["L"] = "next_source",
  --         },
  --       },
  --       filesystem = {
  --         follow_current_file = {
  --           enabled = true,
  --         },
  --         hijack_netrw_behavior = "open_current",
  --         use_libuv_file_watcher = true,
  --       },
  --     }
  --   end,
  -- },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
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
        width = 30,
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
  },
}

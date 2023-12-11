local icons = require("copper.utils.icons")

return {
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
        -- TODO: Fix loading the icons correctly
        -- git_status = { symbols = icons.git },
        -- diagnostics = { symbols = icons.diagnostics },
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
        },                       -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
      },
      async_directory_scan = "always",
    },
    -- A simple version which just opens neotree when starting nvim but leaves the other standard behaviour like opening an empty buffer as is.
    -- init = function()
    --   vim.g.neo_tree_remove_legacy_commands = 1
    --   vim.cmd("Neotree show")
    -- end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      -- TODO: Somehow this seems to interfere with diagnostics sign icons in the statuscol
      -- Function to close the empty buffer
      local function close_empty_buffer()
        vim.defer_fn(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == "" and vim.api.nvim_buf_line_count(buf) == 1 then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end, 10)
      end

      -- Open Neo-tree if Neovim is started with a directory or no arguments
      if vim.fn.argc() == 0 or (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1) then
        vim.cmd("Neotree reveal") -- Open Neo-tree in the current directory or default to home
        close_empty_buffer()
      end

      -- Auto-command to close the empty buffer when a file is opened from Neo-tree
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          if vim.fn.winnr('$') == 1 and vim.fn.bufname() ~= "" then
            close_empty_buffer()
          end
        end
      })
    end,
  },

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

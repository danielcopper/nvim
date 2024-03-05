local icons = require("copper.config.icons")

return {
  "nvim-neo-tree/neo-tree.nvim",
  -- TODO: Reactivate once file following feature is fixed
  enabled = true,
  cmd = "Neotree",
  dependencies = {
    "mrbjarksen/neo-tree-diagnostics.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim"
  },
  keys = {
    { "<leader>fe", "<Cmd>Neotree focus<CR>",  { desc = "Focus on Neotree" } },
    { "<leader>te", "<Cmd>Neotree toggle<CR>", { desc = "Toggle Neotree" } },
  },
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = {
    sources = {
      "filesystem",
      "buffers",
      "git_status",
      "diagnostics",
      "document_symbols" --[[ , ]]
    },
    source_selector = {
      winbar = true, -- toggle to show selector on winbar
      content_layout = "center",
      tabs_layout = "equal",
      show_separator_on_edge = true,
      sources = {
        { source = "filesystem",       display_name = icons.ui.ProjectAlt },
        { source = "buffers",          display_name = icons.ui.Buffer },
        { source = "git_status",       display_name = icons.ui.GitHub },
        { source = "document_symbols", display_name = icons.ui.Symbols },
        { source = "diagnostics",      display_name = icons.ui.Diagnostics },
      },
    },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        with_markers = true,
        indent_marker = icons.borders.Left,
        last_indent_marker = icons.borders.BottomLeft,
      },
      icon = {
        folder_closed = icons.ui.folder_closed,
        folder_open = icons.ui.folder_open,
        folder_empty = icons.ui.folder_empty,
        folder_empty_open = icons.ui.folder_empty_open,
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = icons.ui.Text,
      },
      modified = { symbol = icons.ui.ModifiedFile },
      git_status = { symbols = icons.git },
      diagnostics = { symbols = icons.diagnostics },
    },
    window = {
      width = 40,
      mappings = {
        -- ["<space>"] = false, -- disable space until we figure out which-key disabling
        ["H"] = "prev_source",
        ["L"] = "next_source",
        ["<space>"] = "none",
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
      group_empty_dirs = true,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    async_directory_scan = "always",
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- NOTE: The goal is to have the active tab shown normally and the others transparent
    -- vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { fg = 'NONE', bg = 'NONE' })
    -- vim.api.nvim_set_hl(0, 'NeoTreeTabInactive', { fg = 'NONE', bg = 'NONE' })
    -- vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorActive', { fg = 'NONE', bg = 'NONE' })
    -- vim.api.nvim_set_hl(0, 'NeoTreeTabSeparatorInactive', { fg = 'NONE', bg = 'NONE' })
  end,
}

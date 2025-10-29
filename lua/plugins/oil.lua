-- Oil.nvim: Edit your filesystem like a buffer

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    { "_", "<cmd>Oil .<cr>", desc = "Open current directory" },
  },
  opts = {
    -- Skip confirmation for simple operations
    skip_confirm_for_simple_edits = true,

    -- Keymaps in oil buffer
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-r>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },

    -- View options
    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, bufnr)
        return vim.startswith(name, ".")
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
    },

    -- Use trash for delete operations (cross-platform)
    delete_to_trash = true,

    -- Window configuration
    float = {
      padding = 2,
      max_width = 90,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
  },
}

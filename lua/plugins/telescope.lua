-- Telescope: Fuzzy finder for files, text, and more

local helpers = require("config.theme.helpers")
local icons = require("config.theme.icons")

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    -- Files
    { "<leader>ff", "<cmd>Telescope find_files<cr>",    desc = "Find files" },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>",      desc = "Old/recent files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",       desc = "Buffers" },

    -- Search
    { "<leader>fs", "<cmd>Telescope live_grep<cr>",     desc = "Search (grep)" },
    { "<leader>fw", "<cmd>Telescope grep_string<cr>",   desc = "Word under cursor" },

    -- Vim
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",     desc = "Help tags" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>",       desc = "Keymaps" },
    { "<leader>fc", "<cmd>Telescope commands<cr>",      desc = "Commands" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>",   desc = "Diagnostics" },
    { "<leader>fz", "<cmd>Telescope spell_suggest<cr>", desc = "Spell suggest" },

    -- Resume last picker
    { "<leader>f.", "<cmd>Telescope resume<cr>",        desc = "Resume last picker" },
  },
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        -- Theme values
        borderchars = helpers.get_telescope_borderchars(),
        prompt_prefix = icons.ui.search .. " ",
        selection_caret = icons.ui.arrow_right .. " ",
        entry_prefix = "  ",

        -- Functional config
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },

        path_display = { "smart" },
        dynamic_preview_title = true, -- Show filename in preview title

        mappings = {
          i = {
            -- Navigation
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            -- Scrolling preview
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            -- Send to quickfix
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,

            -- Close telescope
            ["<C-c>"] = actions.close,
            ["<esc>"] = actions.close,
          },

          n = {
            ["q"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          },
        },

        -- Open files in the first normal buffer (not special buffers)
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
      },

      pickers = {
        find_files = {
          hidden = false,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        buffers = {
          sort_lastused = true,
          sort_mru = true,
        },
        -- LSP pickers with better path display
        lsp_references = {
          path_display = { "truncate" }, -- Show more of the path
          show_line = true,
          fname_width = 50, -- Adjust filename column width
        },
        lsp_definitions = {
          path_display = { "truncate" },
          show_line = true,
          fname_width = 50,
        },
        lsp_implementations = {
          path_display = { "truncate" },
          show_line = true,
          fname_width = 50,
        },
        lsp_type_definitions = {
          path_display = { "truncate" },
          show_line = true,
          fname_width = 50,
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)

    -- Load fzf extension for better performance
    pcall(telescope.load_extension, "fzf")
  end,
}

vim.pack.add({
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local icons = require("icons")
local ui = require("ui")
local actions = require("telescope.actions")

local telescope = require("telescope")

telescope.setup({
  defaults = {
    prompt_prefix = icons.ui.search .. " ",
    selection_caret = " ",
    entry_prefix = " ",
    borderchars = ui.borderchars,

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
    dynamic_preview_title = true,

    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-c>"] = actions.close,
        ["<esc>"] = actions.close,
      },
      n = {
        ["q"] = actions.close,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
    },

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
    lsp_references = { path_display = { "truncate" }, show_line = true, fname_width = 50 },
    lsp_definitions = { path_display = { "truncate" }, show_line = true, fname_width = 50 },
    lsp_implementations = { path_display = { "truncate" }, show_line = true, fname_width = 50 },
    lsp_type_definitions = { path_display = { "truncate" }, show_line = true, fname_width = 50 },
    git_status = {
      git_icons = {
        added = icons.git.add:gsub("%s+$", ""),
        changed = icons.git.change:gsub("%s+$", ""),
        copied = icons.git.add:gsub("%s+$", ""),
        deleted = icons.git.delete:gsub("%s+$", ""),
        renamed = icons.git.renamed:gsub("%s+$", ""),
        unmerged = icons.git.conflict:gsub("%s+$", ""),
        untracked = icons.git.untracked,
      },
    },
  },

  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "notify")
pcall(telescope.load_extension, "ui-select")

-- Keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", function()
  local cwd = vim.fn.getcwd()
  local git_path = cwd .. "/.git"
  local is_main_repo = vim.fn.isdirectory(git_path) == 1
  require("telescope.builtin").oldfiles({
    cwd_only = true,
    file_ignore_patterns = is_main_repo and { "%.worktrees/" } or nil,
  })
end, { desc = "Recent files (cwd)" })
vim.keymap.set("n", "<leader>fR", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files (all)" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_status<cr>", { desc = "Git changed files" })
vim.keymap.set("n", "<leader>fG", function()
  local default_branch = vim.fn
    .system("git rev-parse --abbrev-ref origin/HEAD"):gsub("%s+$", ""):gsub("^origin/", "")
  if vim.v.shell_error ~= 0 or default_branch == "" then
    vim.notify("Could not determine default branch (run: git remote set-head origin --auto)", vim.log.levels.WARN)
    return
  end
  local base = vim.fn.system("git merge-base " .. default_branch .. " HEAD"):gsub("%s+$", "")
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to find merge base", vim.log.levels.WARN)
    return
  end
  local output = vim.fn.systemlist("git diff --name-only " .. base .. "...HEAD")
  if #output == 0 then
    vim.notify("No changed files in this branch", vim.log.levels.INFO)
    return
  end
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Branch changed files (vs " .. default_branch .. ")",
      finder = require("telescope.finders").new_table({ results = output }),
      sorter = require("telescope.config").values.generic_sorter({}),
      previewer = require("telescope.config").values.file_previewer({}),
    })
    :find()
end, { desc = "Git branch changes" })

vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Search (grep)" })
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Word under cursor" })

vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fz", "<cmd>Telescope spell_suggest<cr>", { desc = "Spell suggest" })

vim.keymap.set("n", "<leader>f.", "<cmd>Telescope resume<cr>", { desc = "Resume last picker" })

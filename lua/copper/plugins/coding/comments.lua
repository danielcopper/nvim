local icons = require("copper.utils.icons")

return {
  {
    "numToStr/Comment.nvim",
    event = { "BufEnter" },
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    opts = {
      signs = true,      -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = { icon = icons.ui.Bug, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, },
        TODO = { icon = icons.ui.CheckAlt2, color = "info", alt = { "todo", "ToDo", "Todo", "toDo" } },
        HACK = { icon = icons.ui.Fire, color = "warning", alt = { "hack", "Hack" } },
        WARN = { icon = icons.diagnostics.Warning, color = "warning", alt = { "WARNING", "XXX", "warn", "warning" }, },
        PERF = { icon = icons.ui.History, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.ui.Electric, color = "hint", alt = { "INFO" } },
        TEST = { icon = icons.ui.Time, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = { fg = "NONE" },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true,                -- enable multine todo comments
        multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
        before = "",                     -- "fg" or "bg" or empty
        keyword = "wide",                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg",                    -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true,            -- uses treesitter to match keywords in comments only
        max_line_len = 400,              -- ignore lines longer than this
        exclude = {},                    -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
    keys = {
      vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" }),
      vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" }),
      vim.keymap.set("n", "<leader>xt", "<Cmd>TodoTrouble<CR>", { desc = "Open TodoTrouble" }),
      vim.keymap.set("n", "<leader>xT", "<Cmd>TodoTrouble<CR>", { desc = "Todo/Fix/Fixme (Trouble)" }),
    },
  },

  -- allows generating block comments like jsdoc
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = {
      vim.keymap.set("n", "<leader>gc", ":lua require('neogen').generate()<CR>", { desc = "Generate comment block" }),
      vim.keymap.set("n", "<Leader>gcf", ":lua require('neogen').generate({ type = 'class' })<CR>",
        { desc = " Generate comment block for function" }),
      vim.keymap.set("n", "<Leader>gcc", ":lua require('neogen').generate({ type = 'class' })<CR>",
        { desc = " Generate comment block for class" }),
      vim.keymap.set("n", "<Leader>gct", ":lua require('neogen').generate({ type = 'class' })<CR>",
        { desc = " Generate comment block for type" }),
      vim.keymap.set("n", "<Leader>gcF", ":lua require('neogen').generate({ type = 'class' })<CR>",
        { desc = " Generate comment block for file" })
    },
    config = true,
  },

  {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    keys = {
      vim.keymap.set("n", "<leader>dg", "<CMD>DogeGenerate<CR>", { desc = "Generate comment block with DoGe" }),
    },
    event = "BufReadPre",
  },
}

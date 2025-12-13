return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = function()
    local helpers = require("config.theme.helpers")
    local border = helpers.get_border()

    return {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      picker = {
        enabled = false, -- Disabled: using telescope-ui-select instead
      },
      quickfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = {
        enabled = true,
        win = {
          border = border,
        },
      },
      rename = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    }
  end,

  keys = {
    -- Terminal
    { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
    { "<C-_>", function() Snacks.terminal() end, desc = "Toggle terminal (which-key)", mode = { "n", "t" } },

    -- LazyGit
    { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "LazyGit current file history" },

    -- Buffer delete
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Delete all buffers" },

    -- Words (toggle highlight)
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup notification system
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd
      end,
    })
  end,
}

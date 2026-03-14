return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    picker = { enabled = false }, -- Using telescope-ui-select instead
    quickfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = false },
    rename = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },

  keys = {
    -- Terminal
    { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
    { "<C-_>", function() Snacks.terminal() end, desc = "Toggle terminal (which-key)", mode = { "n", "t" } },

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

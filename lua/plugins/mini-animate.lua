return {
  "declancm/cinnamon.nvim",
  event = "VeryLazy",
  config = function()
    local cinnamon = require("cinnamon")

    cinnamon.setup({
      options = {
        delay = 3, -- Delay between each movement step (ms) - lower = faster
        max_delta = {
          time = 100, -- Max animation time (ms)
        },
      },
      keymaps = {
        basic = false, -- Don't use default keymaps
        extra = false,
      },
    })

    -- Custom keymaps with centering
    vim.keymap.set("n", "<C-d>", function()
      cinnamon.scroll("<C-d>zz")
    end, { desc = "Scroll down and center" })

    vim.keymap.set("n", "<C-u>", function()
      cinnamon.scroll("<C-u>zz")
    end, { desc = "Scroll up and center" })

    vim.keymap.set("n", "<C-f>", function()
      cinnamon.scroll("<C-f>zz")
    end, { desc = "Page down and center" })

    vim.keymap.set("n", "<C-b>", function()
      cinnamon.scroll("<C-b>zz")
    end, { desc = "Page up and center" })
  end,
}

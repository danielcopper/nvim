return {
  -- animate scrolling and cursor movements
  -- TODO: C-f and C-b are overwritten by this! Disable that -> it interferes with cmp => !!!
  {
    "declancm/cinnamon.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("cinnamon").setup({
        -- Disable the plugin
        disabled = false,
        keymaps = {
          -- Enable the provided 'basic' keymaps
          basic = true,
          -- Enable the provided 'extra' keymaps
          extra = false,
        },
        options = {
          -- Post-movement callback
          callback = function() end,
          -- Delay between each movement step (in ms)
          delay = 7,
          max_delta = {
            -- Maximum delta for line movements
            line = 150,
            -- Maximum delta for column movements
            column = 200,
          },
          -- The scrolling mode
          -- `cursor`: Smoothly scrolls the cursor for any movement
          -- `window`: Smoothly scrolls the window only when the cursor moves out of view
          mode = "cursor",
        },
      })
    end,
  },
}

return {
  "echasnovski/mini.animate",
  event = "VeryLazy",
  config = function()
    require("mini.animate").setup({
      -- scroll = {
      --   timing = require("mini.animate").gen_timing.linear({ duration = 50, unit = "total" }),
      -- },
    })
  end,
}

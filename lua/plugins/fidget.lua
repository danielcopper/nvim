return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    notification = {
      window = {
        winblend = 0, -- Make background solid (not transparent)
        normal_hl = "Normal", -- Use Normal highlight instead of Comment
      },
    },
  },
}

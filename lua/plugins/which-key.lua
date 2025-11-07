-- Which-key: Show keybindings in a popup

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500,
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find/file" },
      { "<leader>g", group = "git" },
      { "<leader>n", group = "notifications" },
      { "<leader>r", group = "rename" },
      { "<leader>u", group = "ui/toggle" },
      { "<leader>v", group = "view" },
      { "<leader>x", group = "diagnostics/quickfix" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "z", group = "fold" },
    },
    win = {
      border = "none",
    },
    icons = {
      mappings = true,
      keys = {
        Up = "󰁝 ",
        Down = "󰁅 ",
        Left = "󰁍 ",
        Right = "󰁔 ",
        Space = "󱁐 ",
        BS = "󰁮 ",
        Esc = "󱊷 ",
        CR = "󰌑 ",
        Tab = "󰌒 ",
        C = "󰘴 ",
        S = "󰘶 ",
        M = "󰘵 ",
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

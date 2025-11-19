-- Which-key: Show keybindings in a popup

local helpers = require("config.theme.helpers")
local icons = require("config.theme.icons")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      win = {
        border = helpers.get_border(),
      },
      preset = "modern",
    delay = 500,
    spec = {
      { "<leader>a", group = "ai/claude", icon = { icon = icons.ui.ai, color = "azure" } },
      { "<leader>b", group = "buffer", icon = { icon = icons.ui.buffer, color = "cyan" } },
      { "<leader>c", group = "code", icon = { icon = icons.ui.code, color = "orange" } },
      { "<leader>f", group = "find/file", icon = { icon = icons.ui.find, color = "green" } },
      { "<leader>g", group = "git", icon = { icon = icons.git.branch, color = "purple" } },
      { "<leader>n", group = "notifications", icon = { icon = icons.ui.notifications, color = "blue" } },
      { "<leader>r", group = "rename", icon = { icon = icons.ui.rename, color = "yellow" } },
      { "<leader>u", group = "ui/toggle", icon = { icon = icons.ui.toggle, color = "cyan" } },
      { "<leader>v", group = "view", icon = { icon = icons.ui.view, color = "blue" } },
      { "<leader>x", group = "diagnostics/quickfix", icon = { icon = icons.diagnostics.error, color = "red" } },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "z", group = "fold" },
      { "q", icon = { icon = icons.ui.close, color = "red" } },
      { "y", icon = { icon = icons.ui.yank, color = "yellow" } },
      { "d", icon = { icon = icons.ui.delete, color = "red" } },
      { "s", icon = { icon = icons.ui.surround, color = "orange" } },
      { "t", icon = { icon = icons.ui.terminal, color = "cyan" } },
    },
    -- Window border configured automatically by harmony
    icons = {
      mappings = true,
      keys = {
        Up = icons.ui.arrow_up,
        Down = icons.ui.arrow_down,
        Left = icons.ui.arrow_left,
        Right = icons.ui.arrow_right,
        Space = icons.ui.Space,
        BS = icons.ui.BS,
        Esc = icons.ui.Esc,
        CR = icons.ui.CR,
        Tab = icons.ui.Tab,
        C = icons.ui.C,
        S = icons.ui.S,
        M = icons.ui.M,
      },
    },
    }
  end,
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

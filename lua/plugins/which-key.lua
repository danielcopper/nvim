-- Which-key: Show keybindings in a popup

local icons = require("config.icons")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500,
    spec = {
      { "<leader>a", group = "ai/claude", icon = { icon = icons.ui.ai, color = "azure" } },
      { "<leader>b", group = "buffer", icon = { icon = icons.ui.buffer, color = "cyan" } },
      { "<leader>c", group = "code", icon = { icon = icons.ui.code, color = "orange" } },
      { "<leader>d", group = "debug", icon = { icon = icons.ui.debug, color = "red" } },
      { "<leader>f", group = "find/file", icon = { icon = icons.ui.find, color = "green" } },
      { "<leader>g", group = "git", icon = { icon = icons.git.branch, color = "purple" } },
      { "<leader>h", group = "hunks", icon = { icon = icons.ui.hunk, color = "orange" } },
      { "<leader>j", group = "jupyter", icon = { icon = icons.ui.jupyter, color = "yellow" } },
      { "<leader>n", group = "notifications", icon = { icon = icons.ui.notifications, color = "blue" } },
      { "<leader>p", group = "pr/azure", icon = { icon = icons.git.branch, color = "azure" } },
      { "<leader>pl", group = "load" },
      { "<leader>po", group = "open" },
      { "<leader>ps", group = "submit" },
      { "<leader>nt", group = "neovim tips", icon = { icon = icons.diagnostics.hint, color = "yellow" } },
      { "<leader>r", group = "rename", icon = { icon = icons.ui.rename, color = "yellow" } },
      { "<leader>s", group = "search", icon = { icon = icons.ui.search, color = "green" } },
      { "<leader>t", group = "tree/explorer", icon = { icon = icons.ui.tree, color = "green" } },
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

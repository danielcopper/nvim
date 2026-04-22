vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local icons = require("icons")
local ui = require("ui")

require("which-key").setup({
  preset = "modern",
  delay = 500,
  win = { border = ui.borders },
  spec = {
    { "<leader>a", group = "ai/claude", icon = { icon = icons.ui.ai, color = "azure" } },
    { "<leader>b", group = "buffer", icon = { icon = icons.ui.buffer, color = "cyan" } },
    { "<leader>c", group = "code", icon = { icon = icons.ui.code, color = "orange" } },
    { "<leader>d", group = "debug", icon = { icon = icons.ui.debug, color = "red" } },
    { "<leader>f", group = "find/file", icon = { icon = icons.ui.find, color = "green" } },
    { "<leader>g", group = "git", icon = { icon = icons.git.branch, color = "purple" } },
    { "<leader>h", group = "hunk", icon = { icon = icons.git.change, color = "purple" } },
    { "<leader>r", group = "request", icon = { icon = icons.ui.http, color = "orange" } },
    { "<leader>j", group = "jupyter", icon = { icon = icons.ui.jupyter, color = "yellow" } },
    { "<leader>n", group = "neovim", icon = { icon = icons.ui.nvim, color = "green" } },
    { "<leader>p", group = "pr/azure", icon = { icon = icons.git.branch, color = "azure" } },
    { "<leader>pl", group = "load" },
    { "<leader>po", group = "open" },
    { "<leader>ps", group = "submit" },
    { "<leader>s", group = "search", icon = { icon = icons.ui.search, color = "green" } },
    { "<leader>t", group = "tools", icon = { icon = icons.ui.tree, color = "green" } },
    { "<leader>tt", group = "tips", icon = { icon = icons.diagnostics.hint, color = "yellow" } },
    { "<leader>u", group = "ui/toggle", icon = { icon = icons.ui.toggle, color = "cyan" } },
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
})

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

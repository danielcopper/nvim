-- Noice: Better UI for messages, cmdline, and popupmenu

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = { enabled = true, silent = true },
      signature = { enabled = true },
      progress = { enabled = false }, -- Using fidget.nvim
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
    },
    routes = {
      { filter = { event = "notify" }, view = "notify" },
    },
  },
}

vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/folke/noice.nvim",
})

local borders = require("ui").borders

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = { enabled = true, silent = true },
    signature = { enabled = true },

    progress = { enabled = false }, -- Using native LspProgress + ui2
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = borders ~= "none",
  },
  views = {
    cmdline_popup = {
      border = {
        style = borders,
        padding = borders == "none" and { 1, 1 } or { 0, 1 },
      },
      win_options = {
        winhighlight = "Normal:NoiceCmdlineNormal,FloatBorder:NoiceCmdlineBorder",
      },
    },
    popupmenu = { border = { style = borders } },
    hover = {
      border = { style = borders, padding = { 1, 2 } },
      -- Force popup below cursor (anchor = NW, 2 rows down)
      relative = "cursor",
      anchor = "NW",
      position = { row = 2, col = 0 },
    },
  },
  routes = {
    -- Suppress LSP "quit with exit code" warnings — always noise from force-stopped servers (e.g. worktree switch)
    { filter = { event = "notify", find = "quit with exit code" }, opts = { skip = true } },
    { filter = { event = "notify" }, view = "notify" },
  },
})

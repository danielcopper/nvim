-- Render-markdown: Better markdown rendering in Neovim

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    -- Headings
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    -- Code blocks
    code = {
      enabled = true,
      sign = true,
      style = "full",
      left_pad = 0,
      right_pad = 0,
      width = "block",
      border = "thin",
    },
    -- Bullet points
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    -- Checkboxes
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },
    -- Quotes
    quote = {
      enabled = true,
      icon = "▋",
    },
    -- Tables
    pipe_table = {
      enabled = true,
      style = "full",
      cell = "padded",
      border = {
        "┌", "┬", "┐",
        "├", "┼", "┤",
        "└", "┴", "┘",
        "│", "─",
      },
    },
    -- Callouts (like >[!NOTE])
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
    },
    -- Anti-conceal: Show markup when cursor is on line
    anti_conceal = {
      enabled = true,
    },
  },
}

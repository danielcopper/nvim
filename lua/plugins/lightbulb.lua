-- Lightbulb: Show code action indicators

return {
  "kosayoda/nvim-lightbulb",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    priority = 10,
    hide_in_unfocused_buffer = true,
    sign = {
      enabled = true,
      text = "💡",
      hl = "DiagnosticSignInfo",
    },
    virtual_text = {
      enabled = false,
    },
    float = {
      enabled = false,
    },
    status_text = {
      enabled = false,
    },
    autocmd = {
      enabled = true,
      updatetime = 200,
      events = { "CursorHold", "CursorHoldI" },
    },
  },
}

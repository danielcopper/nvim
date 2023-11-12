-- Garbage collector that stops inactive LSP clients to free RAM
return {
  "zeioth/garbage-day.nvim",
  event = "BufEnter",
  opts = {
    grace_period = 60 * 15,
    excluded_filetypes = { "java", "markdown" },
    stop_invisible = false,
    notifications = true
  }
}

return {
  "cameron-wags/rainbow_csv.nvim",
  config = true,
  ft = { "csv", "tsv" },
  init = function()
    -- Avoid updating the statusline value
    vim.g.disable_rainbow_statusline = 1
  end,
}

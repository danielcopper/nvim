-- Jupytext: convert between .ipynb and .py formats (better git diffs)
-- Disabled: uses deprecated vim.validate{} API, healthcheck crashes

return {
  "GCBallesteros/jupytext.nvim",
  enabled = false,
  config = function()
    require("jupytext").setup({
      style = "percent",       -- Use "# %%" style cell markers
      output_extension = "py", -- Convert notebooks to .py files
      force_ft = "python",     -- Set filetype to python

      custom_language_formatting = {
        python = {
          extension = "py",
          style = "percent",
          force_ft = "python",
        },
      },
    })
  end,
}

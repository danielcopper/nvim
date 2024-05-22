return {
  "rest-nvim/rest.nvim",
  enabled = false,
  -- TODO: find out why this does not work
  -- build = ":TSInstall http json",
  dependencies = { { "nvim-lua/plenary.nvim" } },
  keys = {
    { "<leader>rr", "<Plug>RestNvim",        desc = "Run the request under the cursor" },
    { "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview the request command" },
    { "<leader>rl", "<Plug>RestNvimLast",    desc = "Re-run last rest request" }
  },
  init = function()
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.http",
      command = "set filetype=http",
    })
  end,
  opts = {}
}

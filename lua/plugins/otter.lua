return {
  "jmbuhr/otter.nvim",
  enabled = false,
  ft = { "markdown", "quarto", "rmd" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    lsp = {
      -- hover = {
      --   border = "rounded",
      -- },
    },
    buffers = {
      set_filetype = true,
      write_to_disk = false,
    },
  },
  config = function(_, opts)
    require("otter").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "quarto", "rmd" },
      callback = function()
        local otter = require("otter")
        otter.activate({ "python", "javascript", "typescript", "lua", "bash" })
      end,
    })
  end,
}

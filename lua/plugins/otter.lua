-- Otter: LSP for embedded code in markdown/quarto

return {
  "jmbuhr/otter.nvim",
  ft = { "markdown", "quarto", "rmd" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    lsp = {
      hover = {
        border = "rounded",
      },
    },
    buffers = {
      set_filetype = true,
      write_to_disk = false,
    },
  },
  config = function(_, opts)
    require("otter").setup(opts)

    -- Auto-activate otter for markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "quarto", "rmd" },
      callback = function()
        local otter = require("otter")
        -- Activate for common embedded languages
        otter.activate({ "python", "javascript", "typescript", "lua", "bash" })
      end,
    })
  end,
}

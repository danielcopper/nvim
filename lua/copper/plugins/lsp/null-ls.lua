return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local null_ls_utils = require("null-ls.utils")

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup({
      -- add package.json as additional identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      sources = {
        -- formatting.stylua, -- lua formatter
        formatting.prettier.with({
          filetypes = { "markdown" },
          extra_args = { "--print-width", "80", "--prose-wrap", "always" },
        }),
        formatting.prettier.with({
          filetypes = { "css", "scss" },
          extra_args = {}
        }),
        formatting.prettier.with({
          filetypes = { "yaml", "yml" },
          extra_args = {}
        }),

        -- diagnostics.eslint_d,
        diagnostics.markdownlint,
      },
    })
  end,
}

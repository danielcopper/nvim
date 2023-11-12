return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
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

        diagnostics.eslint_d.with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" })
          end,
        }),
        diagnostics.markdownlint,
      },
    })
  end,
}

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
    local hover = null_ls.builtins.hover

    null_ls.setup({
      -- add package.json as additional identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      sources = {
        -- formatting.stylua, -- lua formatter
        formatting.prettier.with({
          filetypes = { "css", "scss" },
          extra_args = {}
        }),
        formatting.prettier.with({
          filetypes = { "html" },
          extra_args = {
            "--bracket-same-line",
            "--trailing-comma", "all",
            "--tab-width", "2",
            "--semi",
            "--single-quote",
            "--html-whitespace-sensitivity", "ignore"
          }
        }),
        -- formatting.markdownlint,
        formatting.prettier.with({
          filetypes = { "markdown" },
          extra_args = { "--print-width", "80", "--prose-wrap", "always" },
        }),
        formatting.prettier.with({
          filetypes = { "yaml", "yml" },
          extra_args = {}
        }),
        formatting.sqlfluff.with({
          extra_args = { "--dialect", "tsql" },
        }),

        -- diagnostics.eslint_d, -- deprecated
        diagnostics.editorconfig_checker,
        diagnostics.gitlint,
        diagnostics.markdownlint,
        diagnostics.sqlfluff.with({
          -- extra_args = { "--dialect", "postgres" },         -- change to your dialect
          extra_args = { "--dialect", "tsql" },
        }),
        diagnostics.yamllint,

        -- NOTE: Not sure if this actually works
        -- Shows the first available definition for the current word under the cursor.
        hover.dictionary,
        -- Shows the value for the current environment variable under the cursor. sh dosbatch and ps1
        hover.printenv
      },
    })
  end,
}

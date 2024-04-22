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

    vim.keymap.set("n", "<leader>cf", ":lua vim.lsp.buf.format({ async = true })<CR>",
      { desc = "Quick format the open buffer" })

    null_ls.setup({
      debug = true,
      -- add package.json as additional identifier for root (for typescript monorepos)
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      timeout = 20000, -- ms
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
          extra_args = { "--print-width", "120", "--prose-wrap", "always" },
        }),
        formatting.prettier.with({
          filetypes = { "yaml", "yml" },
          extra_args = {}
        }),
        formatting.sqlfluff.with({
          extra_args = {
            "--dialect", "tsql",
            "--exclude-rules", "RF06,LT01",
            -- "--rules", "L003:line_length=120"
          },
        }),

        -- diagnostics.eslint_d, -- deprecated
        diagnostics.editorconfig_checker,
        diagnostics.gitlint,
        diagnostics.markdownlint.with({
          extra_args = { "--config", '{ "MD013": { "line_length": 120 } }' }           -- Presuming ability to pass config directly
        }),
        -- diagnostics.sqlfluff.with({
        --   -- extra_args = { "--dialect", "postgres" },         -- change to your dialect
        --   extra_args = { "--dialect", "tsql" },
        -- }),
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

local events = { "BufEnter", "BufWritePost", "BufReadPost", "InsertLeave", "BufModifiedSet", "TextChanged" }

return {
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    event = events,
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- markdown = { "markdownlint" },
        -- javascript = { "eslint" },
        -- typescript = { "eslint" },
        -- yaml = { "yamllint" },
        -- editorconfig = { "editorconfig-checker" },
        sql = {
          "sqlfluff"
        }
      }
      lint.linters.sqlfluff.args = {
        "lint",
        "--format=json",
        "--dialect=tsql",
        "--exclude-rules=RF06,LT01",
        "--rules=L003:Line_length=120"
      }

      vim.api.nvim_create_autocmd(events, {
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}

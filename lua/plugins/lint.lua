-- nvim-lint: Linting support

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    -- Linters are automatically installed via mason-packages.lua
    lint.linters_by_ft = {
      -- javascript/typescript linting handled by ESLint LSP
      python = { "ruff" },
      -- lua = { "luacheck" }, -- Disabled: lua_ls LSP already provides diagnostics
      markdown = { "markdownlint" },
      yaml = { "yamllint" },
      json = { "jsonlint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      dockerfile = { "hadolint" },
      sql = { "sqlfluff" },
    }

    -- sqlfluff: default dialect sqlite. A `.sqlfluff` in the project tree
    -- overrides this — when one is found we drop --dialect so sqlfluff reads
    -- it from the config file instead of being forced by the CLI flag.
    -- The switch is done per buffer in an autocmd below.
    local sqlfluff_default = { "lint", "--format=json", "--dialect=sqlite", "-" }
    local sqlfluff_project = { "lint", "--format=json", "-" }
    lint.linters.sqlfluff.args = sqlfluff_default

    lint.linters.yamllint.args = {
      "--format", "parsable",
      "-d", "{extends: default, rules: {line-length: disable}}",
      "-",
    }

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "BufEnter", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function(ev)
        -- Swap sqlfluff dialect args depending on whether the project ships
        -- its own .sqlfluff config. Runs before try_lint so the right args
        -- are active for this buffer.
        if vim.bo[ev.buf].filetype == "sql" then
          local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(ev.buf))
          if dir == "" then
            dir = vim.fn.getcwd()
          end
          local has_cfg = #vim.fs.find({ ".sqlfluff" }, { upward = true, path = dir }) > 0
          lint.linters.sqlfluff.args = has_cfg and sqlfluff_project or sqlfluff_default
        end
        -- Only lint if the buffer has a linter configured
        if lint.linters_by_ft[vim.bo[ev.buf].filetype] then
          lint.try_lint()
        end
      end,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}

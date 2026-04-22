vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff" },
  markdown = { "markdownlint" },
  yaml = { "yamllint" },
  json = { "jsonlint" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  dockerfile = { "hadolint" },
  sql = { "sqlfluff" },
}

local sqlfluff_default = { "lint", "--format=json", "--dialect=sqlite", "-" }
local sqlfluff_project = { "lint", "--format=json", "-" }
lint.linters.sqlfluff.args = sqlfluff_default

lint.linters.yamllint.args = {
  "--format", "parsable",
  "-d", "{extends: default, rules: {line-length: disable}}",
  "-",
}

local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "BufEnter", "InsertLeave" }, {
  group = lint_augroup,
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "sql" then
      local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(ev.buf))
      if dir == "" then
        dir = vim.fn.getcwd()
      end
      local has_cfg = #vim.fs.find({ ".sqlfluff" }, { upward = true, path = dir }) > 0
      lint.linters.sqlfluff.args = has_cfg and sqlfluff_project or sqlfluff_default
    end
    if lint.linters_by_ft[vim.bo[ev.buf].filetype] then
      lint.try_lint()
    end
  end,
})

vim.api.nvim_create_user_command("Lint", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })

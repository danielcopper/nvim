return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = true,
        })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      bash = { "shfmt" },
      sh = { "shfmt" },
      sql = { "sqlfluff" },
    },
    -- Format on save disabled - use <leader>cf instead
    format_on_save = nil,
    -- Customize formatters
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      sqlfluff = {
        -- conform's default requires a .sqlfluff/pyproject.toml etc. to be
        -- present before it'll run at all — disable that so we always format.
        require_cwd = false,
        -- Use `sqlfluff format` (not `fix`): `fix` exits non-zero when it
        -- finds violations it can't auto-fix, which conform treats as a
        -- format failure. `format` is the pure-formatter subcommand (stable
        -- subset of rules, whitespace/layout only) and doesn't fail on
        -- lint issues. When a project `.sqlfluff` exists we drop --dialect
        -- so sqlfluff reads it from config.
        args = function(_, ctx)
          local found = vim.fs.find({ ".sqlfluff" }, {
            upward = true,
            path = vim.fs.dirname(ctx.filename),
          })
          if #found > 0 then
            return { "format", "-" }
          end
          return { "format", "--dialect", "sqlite", "-" }
        end,
      },
    },
  },
}

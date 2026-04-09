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
        -- Override args entirely: sqlfluff wants flags AFTER the subcommand
        -- (`fix --dialect=sqlite -`), so prepend_args (which prepends BEFORE
        -- the default `fix`) wouldn't work. When a project `.sqlfluff` exists
        -- we omit --dialect so sqlfluff reads it from the config file.
        args = function(_, ctx)
          local found = vim.fs.find({ ".sqlfluff" }, {
            upward = true,
            path = vim.fs.dirname(ctx.filename),
          })
          if #found > 0 then
            return { "fix", "-" }
          end
          return { "fix", "--dialect", "sqlite", "-" }
        end,
      },
    },
  },
}

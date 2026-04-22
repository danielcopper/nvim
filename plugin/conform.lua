vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
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
  format_on_save = nil,
  formatters = {
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
    shfmt = {
      prepend_args = { "-i", "2" },
    },
    sqlfluff = {
      require_cwd = false,
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
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format({
    lsp_format = "fallback",
    async = true,
  })
end, { desc = "Format buffer" })

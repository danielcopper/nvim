vim.pack.add({ "https://github.com/Kurren123/mssql.nvim" })

require("mssql").setup({
  keymap_prefix = "<leader>m",

  open_results_in = "split",
  view_messages_in = "notification",
  max_rows = 200,
  max_column_width = 120,
  execute_generated_select_statements = true,

  lsp_settings = {
    format = {
      placeSelectStatementReferencesOnNewLine = true,
      keywordCasing = "Uppercase",
      datatypeCasing = "Uppercase",
      alignColumnDefinitionsInColumns = true,
    },
  },

  sql_buffer_options = {
    expandtab = true,
    tabstop = 2,
    shiftwidth = 2,
    softtabstop = 2,
  },
})

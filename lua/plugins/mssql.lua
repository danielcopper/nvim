-- mssql.nvim: T-SQL language server + query runner for Microsoft SQL Server.
-- Wraps microsoft/sqltoolsservice (same backend as the VSCode mssql extension),
-- auto-downloaded on first setup into stdpath("data") .. "/mssql.nvim".

-- NOTE: we intentionally do NOT trigger on `ft = "sql"`. The plugin registers
-- its LSP with `filetypes = { "sql" }`, which would attach the T-SQL server to
-- every .sql buffer — including SQLite / Postgres / sqlfluff-only projects.
-- Loading only via commands means the LSP is only spun up when you actively
-- want to work against an MSSQL server (`:Connect`, `:NewQuery`, etc.).
return {
  "Kurren123/mssql.nvim",
  cmd = {
    "NewQuery",
    "NewDefaultQuery",
    "Connect",
    "Disconnect",
    "ExecuteQuery",
    "CancelQuery",
    "SwitchDatabase",
    "Find",
    "RefreshCache",
    "EditConnections",
    "SaveQueryResults",
    "BackupDatabase",
    "RestoreDatabase",
  },
  dependencies = { "folke/which-key.nvim" },
  opts = {
    -- Groups all mssql commands under <leader>m (registered with which-key)
    keymap_prefix = "<leader>m",

    -- Result display
    open_results_in = "split",
    view_messages_in = "notification",
    max_rows = 200,
    max_column_width = 120,
    execute_generated_select_statements = true,

    -- T-SQL formatting rules passed through to the SQL Tools Service
    lsp_settings = {
      format = {
        placeSelectStatementReferencesOnNewLine = true,
        keywordCasing = "Uppercase",
        datatypeCasing = "Uppercase",
        alignColumnDefinitionsInColumns = true,
      },
    },

    -- Match the rest of this config: 2-space indent for SQL buffers
    sql_buffer_options = {
      expandtab = true,
      tabstop = 2,
      shiftwidth = 2,
      softtabstop = 2,
    },
  },
}

require("mason-tool-installer").setup({
  ensure_installed = {
    -- Lua
    "lua-language-server",
    "stylua",

    -- TypeScript/JavaScript
    "typescript-language-server",
    "angular-language-server",
    "eslint-lsp",
    "prettier",

    -- HTML/CSS/Web
    "html-lsp",
    "css-lsp",
    "emmet-language-server",

    -- JSON/YAML
    "json-lsp",
    "yaml-language-server",
    "azure-pipelines-language-server",
    "jsonlint",
    "yamllint",

    -- Markdown
    "markdown-oxide",
    "markdownlint",

    -- Python
    "basedpyright",
    "ruff",
    "debugpy",

    -- Bash/Shell
    "bash-language-server",
    "shfmt",
    "shellcheck",

    -- Docker
    "dockerfile-language-server",
    "hadolint",

    -- XML
    "lemminx",

    -- PowerShell
    "powershell-editor-services",

    -- SQL (T-SQL semantic analysis via mssql.nvim / sqltoolsservice,
    -- sqlfluff handles dialect-aware linting + formatting)
    "sqlfluff",

    -- C#
    "roslyn",

    -- Java
    "jdtls",

    -- DAP Adapters
    "netcoredbg",

    -- Code Analysis
    "sonarlint-language-server",
  },

  auto_update = false,
  run_on_start = true,
  start_delay = 3000,
})

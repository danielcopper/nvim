-- Mason Tool Installer: Centralized installation for all Mason packages
-- Single source of truth for LSP servers, formatters, linters, and DAP adapters

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
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
      "marksman",
      "markdown-oxide",
      "markdownlint",

      -- Python
      "pylint",
      "black",
      "isort",

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

      -- C#
      "roslyn",

      -- DAP Adapters
      "netcoredbg",
    },

    -- Automatically update packages on startup
    auto_update = false,

    -- Automatically install packages on startup
    run_on_start = true,

    -- Show notification when installation starts
    start_delay = 3000, -- 3 seconds
  },
}

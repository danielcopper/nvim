vim.pack.add({
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

local icons = require("icons")
local borders = require("ui").borders

require("mason").setup({
  ui = {
    border = borders,
    icons = {
      package_installed = icons.ui.check,
      package_pending = icons.ui.spinner,
      package_uninstalled = icons.ui.close,
    },
  },
  registries = {
    "github:mason-org/mason-registry",
    "github:crashdummyy/mason-registry",
  },
})

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

    -- SQL
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

vim.keymap.set("n", "<leader>tm", "<cmd>Mason<cr>", { desc = "Mason" })

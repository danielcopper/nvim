-- LSP Server Configurations
-- Returns a table of server configurations to be passed to vim.lsp.config()
-- Servers are automatically installed via mason-packages.lua

local M = {}

-- Get capabilities with blink.cmp integration
function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Enhance with blink.cmp capabilities if available
  local has_blink, blink = pcall(require, "blink.cmp")
  if has_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  -- Enable file watcher
  capabilities.workspace = capabilities.workspace or {}
  capabilities.workspace.didChangeWatchedFiles = {
    dynamicRegistration = true,
  }

  return capabilities
end

-- Server configurations
function M.get_servers()
  local capabilities = M.get_capabilities()

  return {
    -- Lua
    lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
            },
          },
          completion = { callSnippet = "Replace" },
          diagnostics = { globals = { "vim" } },
          hint = { enable = true },
        },
      },
    },

    -- TypeScript/JavaScript
    ts_ls = {
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
          },
        },
      },
    },

    -- JSON with schemastore
    jsonls = {
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },

    -- YAML with schemastore
    yamlls = {
      capabilities = capabilities,
      settings = {
        yaml = {
          schemaStore = {
            enable = true,
          },
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    },

    -- Azure Pipelines
    azure_pipelines_ls = {
      capabilities = capabilities,
      cmd = { "azure-pipelines-language-server", "--stdio" },
      filetypes = { "yaml", "yml" },
      root_markers = { "azure-pipelines.yml" },
      workspace_required = true,
      settings = {
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
              "/azure-pipeline*.y*l",
              "/*.azure*",
              "Azure-Pipelines/**/*.y*l",
              "Pipelines/**/*.y*l",
              "pipelines/**/*.y*l",
            },
          },
        },
      },
    },

    -- ESLint (no auto-fix on save)
    eslint = {
      capabilities = capabilities,
      settings = {
        useFlatConfig = false, -- Required for legacy .eslintrc.json with ESLint 9+
      },
    },

    -- Simple servers (use defaults with capabilities)
    bashls = { capabilities = capabilities },
    cssls = { capabilities = capabilities },
    html = { capabilities = capabilities },
    dockerls = { capabilities = capabilities },
    markdown_oxide = { capabilities = capabilities },
    angularls = {
      capabilities = capabilities,
      root_markers = { "angular.json", "nx.json" },
      workspace_required = true,
    },
    emmet_language_server = { capabilities = capabilities },
    powershell_es = {
      capabilities = capabilities,
      settings = {
        powershell = {
          codeFormatting = {
            preset = "OTBS",
            openBraceOnSameLine = true,
            newLineAfterOpenBrace = true,
            newLineAfterCloseBrace = true,
            whitespaceBeforeOpenBrace = true,
            whitespaceBeforeOpenParen = true,
            whitespaceAroundOperator = true,
            whitespaceAfterSeparator = true,
            ignoreOneLineBlock = true,
            alignPropertyValuePairs = true,
            useCorrectCasing = true,
          },
        },
      },
    },
    lemminx = { capabilities = capabilities }, -- XML Language Server

    -- Python
    basedpyright = {
      capabilities = capabilities,
      settings = {
        basedpyright = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
    },
  }
end

return M

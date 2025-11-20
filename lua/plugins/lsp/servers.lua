-- LSP Server Configurations
-- Returns a table of server configurations to be passed to vim.lsp.config()
-- Servers are automatically installed via mason-packages.lua

local M = {}

-- Get capabilities with nvim-cmp integration
function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Enhance with nvim-cmp capabilities if available
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
  end

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
      root_dir = vim.fs.root(0, { "azure-pipelines.yml", ".git" }),
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
        experimental = { useFlatConfig = false }, -- Support legacy .eslintrc.json
      },
    },

    -- Simple servers (use defaults with capabilities)
    bashls = { capabilities = capabilities },
    cssls = { capabilities = capabilities },
    html = { capabilities = capabilities },
    dockerls = { capabilities = capabilities },
    marksman = { capabilities = capabilities },
    markdown_oxide = { capabilities = capabilities },
    angularls = { capabilities = capabilities },
    emmet_language_server = { capabilities = capabilities },
    powershell_es = { capabilities = capabilities },
    lemminx = { capabilities = capabilities }, -- XML Language Server
  }
end

return M

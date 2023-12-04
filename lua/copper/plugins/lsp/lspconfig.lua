local icons = require("copper.utils.icons")

--- Sets up the enhanced capabilities for the LSP client, especially for autocompletion.
-- This function is typically called during the LSP server setup to provide
-- additional features like snippet support, folding range, and other language-specific capabilities.
-- @return table The enhanced capabilities.
local function setup_capabilites()
  -- Set up enhanced capabilities for LSP, especially for autocompletion
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Enables text folding range capabilities in the LSP
  capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

  -- Sets supported formats for hover content (like Markdown or plaintext)
  capabilities.textDocument.hover = {
    contentFormat = { "markdown", "plaintext" },
  }

  -- Enables semantic highlighting, providing more meaningful syntax colors
  capabilities.textDocument.semanticHighlightingCapabilities = {
    semanticHighlighting = true,
  }

  -- Enhances signature help with Markdown and plaintext support
  capabilities.textDocument.signatureHelp = {
    signatureInformation = {
      documentationFormat = { "markdown", "plaintext" },
      parameterInformation = { labelOffsetSupport = true }
    }
  }

  -- Enables workspace folder support and dynamic configuration in LSP
  capabilities.workspace = {
    workspaceFolders = true,
    configuration = true,
  }

  -- Enables code lens capabilities, providing inline actions and information
  capabilities.textDocument.codeLens = { dynamicRegistration = true }

  -- Enhances diagnostics capabilities, including related information and tag support
  capabilities.textDocument.publishDiagnostics = {
    relatedInformation = true,
    versionSupport = false,
    tagSupport = { valueSet = { 1, 2 } }
  }

  -- Enables linked editing range, allowing for simultaneous edits of linked items
  capabilities.textDocument.linkedEditingRange = {
    dynamicRegistration = true
  }

  -- Allows the LSP to support rename preparation, providing more context for renaming
  capabilities.textDocument.prepareRename = {
    dynamicRegistration = true
  }

  -- Enhances code action capabilities with dynamic registration and a variety of code action kinds
  capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = {
          "", -- Empty means all kinds of code actions
          "quickfix",
          "refactor",
          "refactor.extract",
          "refactor.inline",
          "refactor.rewrite",
          "source",
          "source.organizeImports",
        },
      },
    },
  }

  -- Enables range formatting for partial code formatting instead of whole documents
  capabilities.textDocument.rangeFormatting = {
    dynamicRegistration = true,
  }

  -- Enables various synchronization features for the LSP, like willSave, didSave events
  capabilities.textDocument.synchronization = {
    dynamicRegistration = true,
    willSave = true,
    willSaveWaitUntil = true,
    didSave = true,
  }

  -- Enables call hierarchy capabilities, allowing visualization of call chains
  capabilities.textDocument.callHierarchy = {
    dynamicRegistration = true,
  }

  -- Enables type hierarchy capabilities, useful for object-oriented languages
  capabilities.textDocument.typeHierarchy = {
    dynamicRegistration = true,
  }

  -- Enables selection range capabilities, allowing for smart selection of code blocks
  capabilities.textDocument.selectionRange = {
    dynamicRegistration = true,
  }

  -- Enables moniker capabilities, useful for cross-repository navigation
  capabilities.textDocument.moniker = {
    dynamicRegistration = true,
  }

  -- Specifies the regular expression engine and version the LSP should use for searches
  capabilities.textDocument.regularExpressions = {
    engine = "ECMAScript",
    version = "ECMAScript 2020",
  }

  -- Enables inlay hint capabilities, providing inline hints and information
  capabilities.textDocument.inlayHint = {
    dynamicRegistration = true,
  }

  -- Enhances completion items with various features like snippet support and additional documentation formats
  capabilities.textDocument.completion.completionItem = {
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    deprecatedSupport = true,
    labelDetailsSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    documentationFormat = { "markdown", "plaintext" },
    resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }
  }

  return capabilities
end

--- Configures keybindings specifically for LSP functionalities in the provided buffer.
-- Keybindings include shortcuts for go-to definition, references, diagnostics, etc.
-- This function is called in the on_attach callback of each LSP server.
-- @param bufnr number The buffer number where the keybindings will be set.
local function setup_keybindings(bufnr)
  local set = vim.keymap.set
  -- Keybinding setup for LSP functions like go-to definition, references, etc.
  local keybind = function(keys, func, desc)
    set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
  end

  keybind("gd", require("telescope.builtin").lsp_definitions, "Show LSP definitions")
  keybind("gD", vim.lsp.buf.declaration, "Go to declaration")
  keybind("gr", require("telescope.builtin").lsp_references, "Show LSP references")
  keybind("gi", require("telescope.builtin").lsp_implementations, "Show LSP implementations")
  keybind("gt", require("telescope.builtin").lsp_type_definitions, "Show LSP type definitions")
  keybind("<leader>rn", vim.lsp.buf.rename, "Smart rename")
  keybind("<leader>vd", function() vim.diagnostic.open_float(nil, { border = "single" }) end, "Show line diagnostics")
  keybind("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
  keybind("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
  keybind("K", vim.lsp.buf.hover, "Show documentation for what is under the cursor")
  keybind("<leader>rs", ":LspRestart<CR>", "Restart LSP")
  set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
    { buffer = bufnr, noremap = true, silent = true, desc = "See available code actions" })
  set("n", "<leader>vD", "<cmd>Telescope diagnostics bufnr=0<CR>",
    { buffer = bufnr, noremap = true, silent = true, desc = "Show buffer diagnostics" })
end

--- Configures handlers for different LSP server responses.
-- Handlers in LSP are functions that determine how certain types of server responses
-- (like hover, signature help, etc.) are displayed or processed in Neovim.
-- This function sets up customized behavior for these responses, like defining borders
-- or other UI enhancements.
local function setup_handlers()
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
  }

  return handlers
end

--- Sets up diagnostic signs used in the sign column (gutter).
-- This function defines visual indicators (like icons or text) for different types of diagnostics
-- such as errors, warnings, information, and hints. These signs help in quickly identifying
-- the nature of the diagnostic in the code.
local function setup_signs()
  -- Change the diagnostic symbols in the sign column (gutter)
  local signs = {
    Error = icons.diagnostics.Error,
    Warn = icons.diagnostics.Warning,
    Hint = icons.diagnostics.Hint,
    Info = icons.diagnostics.Information,
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

-- Diagnostics
vim.diagnostic.config({
  -- Limit length
  open_float = {
    width = 80,
  },
  -- Enable border
  float = {
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  severity_sort = true,
})

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",                                   -- Integration with nvim-cmp for LSP-based completions
      { "antosha417/nvim-lsp-file-operations", config = true }, -- File operations through LSP
      { "folke/neodev.nvim",                   opts = {} },     -- Enhanced support for Neovim development
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim", -- Validate JSON files
    },
    config = function()
      -- First some general configuration
      -- neodev setup must be done before lspconfig to enhance Lua dev experience
      require("neodev").setup({})

      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      local handlers = setup_handlers()
      local capabilities = setup_capabilites()
      local on_attach = function(_, bufnr) setup_keybindings(bufnr) end

      setup_signs()

      require('lspconfig.ui.windows').default_options.border = 'single'

      -- And second the actual lsp servers setup
      mason.setup({
        ui = {
          icons = {
            package_installed = icons.ui.CheckAlt,
            package_pending = icons.ui.Arrow,
            package_uninstalled = icons.ui.ErrorAlt
          },
          border = "single"
        }
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "angularls",
          "bashls",
          "cssls",
          "cssmodules_ls",
          "emmet_language_server",
          "eslint",
          "html",
          "jsonls",
          "lemminx",
          "lua_ls",
          "marksman",
          "omnisharp",
          "powershell_es",
          "quick_lint_js",
          "sqlls",
          "tsserver",
          "yamlls",
        },
      })

      mason_lspconfig.setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          lspconfig[server_name].setup {
            capabilities = capabilities,
            handlers = handlers,
            on_attach = on_attach
          }
        end,

        ["jsonls"] = function()
          lspconfig.jsonls.setup({
            capabilities = capabilities,
            handlers = handlers,
            on_attach = on_attach,
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,

        -- Next, you can provide a dedicated handler for specific servers.
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                },
                format = {
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = 2
                  }
                },
                hint = { enable = true },
                telemetry = { enable = false },
                workspace = {
                  library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                  },
                },
              },
            },
          })
        end,

        ["powershell_es"] = function()
          lspconfig.powershell_es.setup({
            { bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services" }
          })
        end,

        ["omnisharp"] = function()
          local system_name = vim.loop.os_uname().sysname
          local cmd_path = system_name == "Windows_NT" and
              vim.fn.expand("~\\AppData\\local\\nvim-data\\mason\\packages\\omnisharp\\libexec\\OmniSharp.dll") or
              vim.fn.expand("~/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll")

          require("lspconfig").omnisharp.setup {
            cmd = { "dotnet", cmd_path },
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
            -- NOTE: This is experimental i should check thouroughly if this improves load times for example
            roslynExtensionsOptions = {
              documentAnalysisTimeoutMs = 30000, -- Sets a timeout for document analysis (in milliseconds)
              diagnosticWorkersThreadCount = 4, -- Limits the number of threads for computing diagnostics
            },
            enable_editorconfig_support = true,
            enable_ms_build_load_projects_on_demand = false,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            enableNamespaceSync = true,
            sdk_include_prereleases = true,
            analyze_open_documents_only = false,
          }
        end,
      })
    end,
  },
}

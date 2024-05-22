local icons = require("copper.config.icons")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",                                   -- Integration with nvim-cmp for LSP-based completions
      { "antosha417/nvim-lsp-file-operations", config = true }, -- File operations through LSP
      { "folke/neodev.nvim",                   opts = {} },     -- Enhanced support for Neovim development
      { "williamboman/mason.nvim",             cmd = "Mason" },
      "williamboman/mason-lspconfig.nvim",

      "Hoffs/omnisharp-extended-lsp.nvim",
      -- "iabdelkareem/csharp.nvim",
      -- "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
      -- "mfussenegger/nvim-dap",

      -- "pmizio/typescript-tools.nvim",
      "joeveiga/ng.nvim",

      "b0o/schemastore.nvim",
      -- {
      --   'creativenull/efmls-configs-nvim',
      --   version = 'v1.x.x', -- version is optional, but recommended
      --   dependencies = { 'neovim/nvim-lspconfig' },
      -- }
    },
    config = function()
      -- neodev setup must be done before lspconfig to enhance Lua dev experience
      require("neodev").setup()

      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- SECTION: UI
      -- Handlers in LSP are functions that determine how certain types of server responses
      -- (like hover, signature help, etc.) are displayed or processed in Neovim.
      -- This function sets up customized behavior for these responses, like defining borders
      -- or other UI enhancements.
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = vim.copper_config.borders }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
          { border = vim.copper_config.borders }),
      }

      require('lspconfig.ui.windows').default_options.border = vim.copper_config.borders

      -- TODO: maybe move to options.lua
      for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      -- SECTION: Functionalities
      -- The default neovim supported client capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- Additional completion capabilities for lsps enabled by nvim-cmp
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      -- Enables text folding range capabilities in the LSP (nvim ufo)
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
      -- Enable (broadcasting) snippet capability for completion
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local markdown_oxide_capabilities = capabilities
      markdown_oxide_capabilities.workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      }

      vim.diagnostic.config({
        -- Enable or disable updating diagnostics in insert mode
        update_in_insert = false,
        underline = false,
        -- Configure the floating window for diagnostics
        float = {
          source = 'always', -- Show the source of the diagnostic
          border = vim.copper_config.borders,
        },
      })

      local on_attach = function(_, bufnr)
        local set = vim.keymap.set
        local keybind = function(keys, func, desc)
          set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
        end

        keybind("<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
        keybind("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Quick format the open buffer")
        keybind("gd", require("telescope.builtin").lsp_definitions, "Show LSP definitions")
        keybind("gD", vim.lsp.buf.declaration, "Go to declaration")
        keybind("gr", require("telescope.builtin").lsp_references, "Show LSP references")
        keybind("gi", require("telescope.builtin").lsp_implementations, "Show LSP implementations")
        keybind("gt", require("telescope.builtin").lsp_type_definitions, "Show LSP type definitions")
        keybind("<leader>rn", vim.lsp.buf.rename, "Smart rename")
        keybind("<leader>vd", function() vim.diagnostic.open_float(nil, { border = vim.copper_config.borders }) end,
          "Show line diagnostics")
        keybind("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
        keybind("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
        keybind("K", vim.lsp.buf.hover, "Show documentation for what is under the cursor")
        keybind("<leader>rs", ":LspRestart<CR>", "Restart LSP")
        set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
          { buffer = bufnr, noremap = true, silent = true, desc = "See available code actions" })
        set("n", "<leader>vD", "<cmd>Telescope diagnostics bufnr=0<CR>",
          { buffer = bufnr, noremap = true, silent = true, desc = "Show buffer diagnostics" })

        keybind("<space>wa", vim.lsp.buf.add_workspace_folder, "")
        keybind("<space>wr", vim.lsp.buf.remove_workspace_folder, "")
        keybind("<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "")

        -- Taken from markdown oxide
        -- refresh codelens on TextChanged and InsertLeave as well
        -- TODO: error on 0.10
        -- vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach' }, {
        --   buffer = bufnr,
        --   callback = vim.lsp.codelens.refresh,
        -- })

        -- trigger codelens refresh
        -- vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })

        -- TODO: gives error currently on 0.10
        -- local ng_opts = { noremap = true, silent = true }
        -- local ng = require("ng");
        -- vim.keymap.set("n", "<leader>at", ng.goto_template_for_component({ reuse_window = true }), ng_opts)
        -- vim.keymap.set("n", "<leader>ac", ng.goto_component_with_template_file({ reuse_window = true }), ng_opts)
        -- vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, ng_opts)
      end

      -- SECTION: Server Setups
      mason.setup({
        ui = {
          icons = {
            package_installed = icons.ui.CheckAlt,
            package_pending = icons.ui.Arrow,
            package_uninstalled = icons.ui.ErrorAlt
          },
          border = vim.copper_config.borders
        }
      })

      mason_lspconfig.setup({
        ensure_installed = {
          -- "azure_pipelines_ls",
          "angularls",
          "bashls",
          "cssls",
          "cssmodules_ls",
          "docker_compose_language_service",
          "efm",
          "emmet_language_server",
          "eslint",
          "html",
          "jsonls",
          "lemminx",
          "lua_ls",
          -- "markdown_oxide", -- NOTE: currently not working on windows
          -- fow now use:
          -- :MasonInstall --target=win_x86 markdown-oxide
          "marksman",
          "omnisharp",
          "powershell_es",
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

        -- ["azure_pipelines_ls"] = function()
        --   require("lspconfig").azure_pipelines_ls.setup {
        --     capabilities = capabilities,
        --     handlers = handlers,
        --     on_attach = on_attach,
        --     settings = {
        --       yaml = {
        --         schemas = {
        --           ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
        --             "/azure-pipeline*.y*l",
        --             "/*.azure*",
        --             "Azure-Pipelines/**/*.y*l",
        --             "Pipelines/*.y*l",
        --           },
        --         },
        --       },
        --     },
        --   }
        -- end,

        -- TODO: needs work.
        -- ["efm"] = function()
        --   local sqlfluff = require('efmls-configs.linters.sqlfluff')
        --   local languages = {
        --     sql = { sqlfluff }
        --   }
        --   local efmls_config = {
        --     filetypes = vim.tbl_keys(languages),
        --     settings = {
        --       rootMarkers = { '.git/' },
        --       languages = languages,
        --     },
        --     init_options = {
        --       documentFormatting = true,
        --       documentRangeFormatting = true,
        --     },
        --   }

        ["eslint"] = function()
          lspconfig.eslint.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            on_new_config = function(config, new_root_dir)
              config.settings.workspaceFolder = {
                uri = vim.uri_from_fname(new_root_dir),
                name = vim.fn.fnamemodify(new_root_dir, ':t')
              }
            end,
          })
        end,

        ["html"] = function()
          lspconfig.html.setup({
            capabilities = capabilities,
            handlers = handlers,
            on_attach = on_attach,
            init_options = {
              provideFormatter = false
            }
          })
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
                codelens = true,
                doc = {
                  privateName = { "^_" },
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

        ["markdown_oxide"] = function()
          lspconfig.markdown_oxide.setup({
            capabilities = markdown_oxide_capabilities, -- ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
            on_attach = on_attach,
            handlers = handlers,
            root_dir = lspconfig.util.root_pattern('.git', vim.fn.getcwd()), -- this is a temp fix for an error in the lspconfig for this LS
          })
        end,

        ["powershell_es"] = function()
          lspconfig.powershell_es.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
            bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
            init_options = {
              enableProfileLoading = false,
            }
          })
        end,

        ["omnisharp"] = function()
          local system_name = vim.loop.os_uname().sysname
          local cmd_path = system_name == "Windows_NT" and
              vim.fn.expand("~\\AppData\\local\\nvim-data\\mason\\packages\\omnisharp\\libexec\\OmniSharp.dll") or
              vim.fn.expand("~/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll")

          require("lspconfig").omnisharp.setup({
            cmd = { "dotnet", cmd_path },
            capabilities = capabilities,
            -- on_attach = on_attach,
            on_attach = function(client, bufnr)
              on_attach(client, bufnr)

              local set = vim.keymap.set
              -- NOTE: Omnisharp seems to have trouble with async formatting so this is here until i find a better solution or rework my lsp setup completely
              set("n", "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Quick format the open buffer" })
              -- set("n", "gd", "<cmd>lua require('omnisharp_extended').lsp_definition()<CR>",
              --   { buffer = bufnr, desc = "OmniSharp LSP definition", noremap = true, silent = true })
              -- set("n", "gr", "<cmd>lua require('omnisharp_extended').lsp_references()<CR>",
              --   { buffer = bufnr, desc = "OmniSharp LSP references", noremap = true, silent = true })
              -- set("n", "gi", "<cmd>lua require('omnisharp_extended').lsp_implementation()<CR>",
              --   { buffer = bufnr, desc = "OmniSharp LSP implementation", noremap = true, silent = true })

              -- Optional: If using Telescope and prefer its integration, you could replace the above with these
              set("n", "gd", "<cmd>lua require('omnisharp_extended').telescope_lsp_definition()<CR>",
                { buffer = bufnr, desc = "OmniSharp LSP definition with Telescope", noremap = true, silent = true })
              set("n", "gr", "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<CR>",
                { buffer = bufnr, desc = "OmniSharp LSP references with Telescope", noremap = true, silent = true })
              set("n", "gi", "<cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<CR>",
                { buffer = bufnr, desc = "OmniSharp LSP implementation with Telescope", noremap = true, silent = true })
            end,
            handlers = handlers,
            settings = {
              FormattingOptions = {
                -- Enables support for reading code style, naming convention and analyzer
                -- settings from .editorconfig.
                EnableEditorConfigSupport = true,
                -- Specifies whether 'using' directives should be grouped and sorted during
                -- document formatting.
                OrganizeImports = true,
              },
              MsBuild = {
                -- If true, MSBuild project system will only load projects for files that
                -- were opened in the editor. This setting is useful for big C# codebases
                -- and allows for faster initialization of code navigation features only
                -- for projects that are relevant to code that is being edited. With this
                -- setting enabled OmniSharp may load fewer projects and may thus display
                -- incomplete reference lists for symbols.
                LoadProjectsOnDemand = nil,
              },
              RoslynExtensionsOptions = {
                -- Enables support for roslyn analyzers, code fixes and rulesets.
                EnableAnalyzersSupport = true,
                -- Enables support for showing unimported types and unimported extension
                -- methods in completion lists. When committed, the appropriate using
                -- directive will be added at the top of the current file. This option can
                -- have a negative impact on initial completion responsiveness,
                -- particularly for the first few completion sessions after opening a
                -- solution.
                EnableImportCompletion = true,
                -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                -- true
                AnalyzeOpenDocumentsOnly = nil,
              },
              Sdk = {
                -- Specifies whether to include preview versions of the .NET SDK when
                -- determining which version to use for project loading.
                IncludePrereleases = true,
              },
            },
          })
        end,

        ["sqlls"] = function()
          lspconfig.sqlls.setup({
            cmd = { "sql-language-server", "up", "--method", "stdio" },
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
            filetypes = { "sql", "mysql", "mdx" }
          })
        end,

        ["yamlls"] = function()
          local schemas = require('schemastore').yaml.schemas()
          schemas["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
            "*.azure*",
            "azure-pipeline*.y*l",
            "Azure-Pipelines/**/*.y*l",
            "Pipelines/**/*.y*l",
            "pipelines/**/*.y*l",
          }

          require("lspconfig").yamlls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            handlers = handlers,
            settings = {
              yaml = {
                format = {
                  enable = true,
                },
                schemas = schemas,
              }
            }
          })
        end,
      })

      --   require("csharp").setup({
      --     -- These are the default values
      --     lsp = {
      --       -- When set to false, csharp.nvim won't launch omnisharp automatically.
      --       enable = true,
      --       -- When set, csharp.nvim won't install omnisharp automatically. Instead, the omnisharp instance in the cmd_path will be used.
      --       cmd_path = nil,
      --       -- The default timeout when communicating with omnisharp
      --       default_timeout = 1000,
      --       -- Settings that'll be passed to the omnisharp server
      --       enable_editor_config_support = true,
      --       organize_imports = true,
      --       load_projects_on_demand = false,
      --       enable_analyzers_support = true,
      --       enable_import_completion = true,
      --       include_prerelease_sdks = true,
      --       analyze_open_documents_only = false,
      --       enable_package_auto_restore = true,
      --       -- Launches omnisharp in debug mode
      --       debug = false,
      --       -- The capabilities to pass to the omnisharp server
      --       capabilities = capabilities,
      --       -- on_attach function that'll be called when the LSP is attached to a buffer
      --       on_attach = on_attach
      --     },
      --     logging = {
      --       -- The minimum log level.
      --       level = "INFO",
      --     },
      --     dap = {
      --       -- When set, csharp.nvim won't launch install and debugger automatically. Instead, it'll use the debug adapter specified.
      --       --- @type string?
      --       adapter_name = nil,
      --     }
      --   })
    end,
  },
}

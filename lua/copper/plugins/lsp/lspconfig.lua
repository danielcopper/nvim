local icons = require("copper.utils.icons")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",                                   -- Integration with nvim-cmp for LSP-based completions
      { "antosha417/nvim-lsp-file-operations", config = true }, -- File operations through LSP
      { "folke/neodev.nvim",                   opts = {} },     -- Enhanced support for Neovim development
    },
    config = function()
      -- neodev setup must be done before lspconfig to enhance Lua dev experience
      require("neodev").setup({})

      local lspconfig = require("lspconfig")
      -- Handlers define how certain LSP responses are displayed
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
      }

      -- Set up enhanced capabilities for LSP, especially for autocompletion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- Explicitly enable snippet support
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      -- Additional capabilities for LSP features like folding and enhanced completion items
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      -- Add additional capabilities for better LSP features (needed for nvim-ufo folds for example)
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
      capabilities.textDocument.completion.completionItem.preselectSupport = true
      capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
      capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
      capabilities.textDocument.completion.completionItem.deprecatedSupport = true
      capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
      capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
      capabilities.textDocument.completion.completionItem.resolveSupport = { properties = { 'documentation', 'detail', 'additionalTextEdits' } }

      local set = vim.keymap.set
      local on_attach = function(_, bufnr)
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
        keybind("<leader>vd", function() vim.diagnostic.open_float(nil, { border = "single" }) end,
          "Show line diagnostics")
        keybind("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
        keybind("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
        keybind("K", vim.lsp.buf.hover, "Show documentation for what is under the cursor")
        keybind("<leader>rs", ":LspRestart<CR>", "Restart LSP")
        set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          { buffer = bufnr, noremap = true, silent = true, desc = "See available code actions" }
        )
        set(
          "n",
          "<leader>vD",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          { buffer = bufnr, noremap = true, silent = true, desc = "Show buffer diagnostics" }
        )
      end

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

      -- Server setup for both standard and custom-configured servers
      -- Standard servers
      local servers_with_standard_config = {
        "bashls",
        "cssls",
        "cssmodules_ls",
        "docker_compose_language_service",
        "dockerls",
        "emmet_language_server",
        "eslint",
        "html",
        "jsonls",
        "lemminx",
        "marksman",
        "sqlls",
        "quick_lint_js",
        "tsserver"
      }

      -- Custom server configurations
      local servers_with_custom_config = {
        angularls = function()
          local ng_cwd = vim.fn.getcwd()
          local ng_project_library_path = ng_cwd .. "/node_modules"
          local ng_cmd = {
            "ngserver",
            "--stdio",
            "--tsProbeLocations",
            ng_project_library_path,
            "--ngProbeLocations",
            ng_project_library_path,
          }
          return {
            cmd = {
              "ngserver",
              "--stdio",
              "--tsProbeLocations", ng_project_library_path,
              "--ngProbeLocations", ng_project_library_path,
            },
            on_new_config = function(new_config, new_root_dir)
              new_config.cmd = ng_cmd
            end,
          }
        end,
        powershell_es = function()
          return { bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services" }
        end,
        yamlls = function()
          return {
            settings = {
              yaml = {
                format = { enable = true },
                schemas = {
                  ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
                    'azure-pipelines.yml', '/pipelines/*.yml', '/Pipelines/*.yml'
                  },
                },
              },
            },
          }
        end,
        omnisharp = function()
          local cmd_path = vim.loop.os_uname().sysname == "Windows_NT" and
              vim.fn.expand("~\\AppData\\local\\nvim-data\\mason\\packages\\omnisharp\\libexec\\OmniSharp.dll") or
              vim.fn.expand("~/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll")
          return {
            cmd = { "dotnet", cmd_path },
            enable_editorconfig_support = true,
            enable_ms_build_load_projects_on_demand = false,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            sdk_include_prereleases = true,
            analyze_open_documents_only = false,
          }
        end,
        lua_ls = function()
          return {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                },
                format = {
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2" -- this is overridden by the editors default settings
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
          }
        end,
      }

      for _, server in ipairs(servers_with_standard_config) do
        lspconfig[server].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
        })
      end

      for server, config_fn in pairs(servers_with_custom_config) do
        lspconfig[server].setup(vim.tbl_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
        }, config_fn()))
      end
    end,
  },
}

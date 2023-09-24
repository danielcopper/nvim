local icons = require("copper.plugins.extras.icons")

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",                          -- source for lsp cmp suggestions
            { "antosha417/nvim-lsp-file-operations", config = true }, -- allows to rename trough file explorer and auto update import statements
            { "folke/neodev.nvim",                   opts = {} }, -- help docs etc. for developing neovim
        },
        config = function()
            -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
            require("neodev").setup({})

            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local set = vim.keymap.set

            local on_attach = function(_, bufnr)
                -- function to simplify kemapping setup
                local keybind = function(keys, func, desc)
                    set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
                end

                keybind("gd", require("telescope.builtin").lsp_definitions, "Show LSP definitions") -- show lsp definitions
                keybind("gD", vim.lsp.buf.declaration, "Go to declaration")                       -- go to declaration
                keybind("gr", require("telescope.builtin").lsp_references, "Show LSP references") -- show definition, references
                keybind("gi", require("telescope.builtin").lsp_implementations, "Show LSP implementations") -- show lsp implementations
                keybind("gt", require("telescope.builtin").lsp_type_definitions, "Show LSP type definitions") -- show lsp type definitions
                keybind("<leader>rn", vim.lsp.buf.rename, "Smart rename")                         -- smart rename
                keybind("<leader>vd", vim.diagnostic.open_float, "Show line diagnostics")         -- show diagnostics for line
                keybind("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")              -- jump to previous diagnostic in buffer
                keybind("]d", vim.diagnostic.goto_next, "Go to next diagnostic")                  -- jump to next diagnostic in buffer
                keybind("K", vim.lsp.buf.hover, "Show documentation for what is under the cursor") -- show documentation for what is under cursor
                keybind("<leader>rs", ":LspRestart<CR>", "Restart LSP")                           -- mapping to restart lsp if necessary
                set(
                    { "n", "v" },
                    "<leader>ca",
                    vim.lsp.buf.code_action,
                    { buffer = bufnr, noremap = true, silent = true, desc = "See available code actions" }
                ) -- see available code actions, in visual mode will apply to selection
                set(
                    "n",
                    "<leader>vD",
                    "<cmd>Telescope diagnostics bufnr=0<CR>",
                    { buffer = bufnr, noremap = true, silent = true, desc = "Show buffer diagnostics" }
                ) -- show  diagnostics for file
            end

            -- LSP capabilites
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- used to enable autocompletion (assign to every lsp server config)
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            -- adding ufo folding capabilities
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }

            local _snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
            ---@diagnostic disable-next-line: inject-field
            _snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true
            local snippet_capabilities = vim.tbl_extend("keep", capabilities, _snippet_capabilities)

            -- Change the Diagnostic symbols in the sign column (gutter)
            local signs = {
                Error = icons.diagnostics.Error,
                Warn = icons.diagnostics.Warn,
                Hint = icons.diagnostics.hint,
                Info = icons.diagnostics.Info,
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Angular
            -- NOTE: These are necessary to make the ls attach properly on windows
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
            lspconfig["angularls"].setup({
                cmd = ng_cmd,
                on_new_config = function(new_config, new_root_dir)
                    new_config.cmd = ng_cmd
                end,
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Lua
            lspconfig["lua_ls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = { -- custom settings for lua
                    Lua = {
                        -- make the language server recognize "vim" global
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            -- make language server aware of runtime files
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                        telemetry = { enable = false },
                        hint = { enable = true },
                    },
                },
            })

            -- C# / OmniSharp
            local windowsDatapath = vim.fn.expand("~") .. "\\AppData\\local\\nvim-data"
            local linuxDatapath = vim.fn.expand("~") .. "/.local/share/nvim"
            require("lspconfig").omnisharp.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "dotnet", windowsDatapath .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
                -- Enables support for reading code style, naming convention and analyzer
                -- settings from .editorconfig.
                enable_editorconfig_support = true,
                -- If true, MSBuild project system will only load projects for files that
                -- were opened in the editor. This setting is useful for big C# codebases
                -- and allows for faster initialization of code navigation features only
                -- for projects that are relevant to code that is being edited. With this
                -- setting enabled OmniSharp may load fewer projects and may thus display
                -- incomplete reference lists for symbols.
                enable_ms_build_load_projects_on_demand = false,
                -- Enables support for roslyn analyzers, code fixes and rulesets.
                enable_roslyn_analyzers = true,
                -- Specifies whether 'using' directives should be grouped and sorted during
                -- document formatting.
                organize_imports_on_format = true,
                -- Enables support for showing unimported types and unimported extension
                -- methods in completion lists. When committed, the appropriate using
                -- directive will be added at the top of the current file. This option can
                -- have a negative impact on initial completion responsiveness,
                -- particularly for the first few completion sessions after opening a
                -- solution.
                enable_import_completion = true,
                -- Specifies whether to include preview versions of the .NET SDK when
                -- determining which version to use for project loading.
                sdk_include_prereleases = true,
                -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                -- true
                analyze_open_documents_only = false,
            })

            -- Powershell
            require("lspconfig").powershell_es.setup({
                bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Auto apply defaults to not specifically setup servers
            -- without snippet support
            local lsp_servers = {
                "bashls",
                "cssmodules_ls",
                "docker_compose_language_service",
                "dockerls",
                "emmet_language_server",
                "eslint",
                "html",
                "marksman",
                "sqlls",
                "quick_lint_js",
                "tsserver",
                "yamlls",
            }
            for _, srv in pairs(lsp_servers) do
                lspconfig[srv].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end

            -- Auto apply defaults to not specifically setup servers
            -- with snippet support
            local lsp_servers_snippet_support = {
                "cssls",
                "html",
                "jsonls",
            }
            for _, srv in pairs(lsp_servers_snippet_support) do
                lspconfig[srv].setup({
                    capabilities = snippet_capabilities,
                    on_attach = on_attach,
                })
            end
        end,
    },

    -- Show a lightbulb where codeactions are available
    {
        "kosayoda/nvim-lightbulb",
        event = { "BufEnter", "BufNewFile" },
        config = function()
            require("nvim-lightbulb").setup({
                autocmd = { enabled = true },
                sign = {
                    enabled = true,
                    -- Text to show in the sign column.
                    -- Must be between 1-2 characters.
                    text = icons.ui.Lightbulb,
                    -- Highlight group to highlight the sign column text.
                    hl = "LightBulbSign",
                },
            })
        end,
    },
}

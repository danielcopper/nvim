return {
    -- LSP Zero simplifies the setup of LSP related plugins
    {
        'VonHeikemen/lsp-zero.nvim',
        enabled = true,
        event = 'BufEnter',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional

            -- Neovim Config specific
            { "folke/neodev.nvim",                opts = {} },
        },
        config = function()
            -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
            require("neodev").setup({})
            local lsp = require("lsp-zero")

            lsp.preset("recommended")

            lsp.ensure_installed({
                'angularls',
                'html',
                'cssls',
                'jsonls',
                'lua_ls',
                'marksman',
                'omnisharp',
                'tsserver',
            })

            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            -- custom keybindings
            local cmp_mappings = lsp.defaults.cmp_mappings({
                -- navigating code suggestions
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            })

            -- disable completion with tab
            cmp_mappings['<Tab>'] = nil
            cmp_mappings['<S-Tab>'] = nil

            lsp.setup_nvim_cmp({
                mapping = cmp_mappings
            })

            -- on_attach happens on every single buffer that has an lsp that's associated with it
            -- that means, that all the following remaps only exist for the current buffer you are on
            -- for example gd on a buffer that has an lsp will use lsp's [g]oto[d]efinition. On a buffer
            -- that has no lsp associated gd will use vim instead to try to jump to definition.
            lsp.on_attach(function(client, bufnr)
                -- NOTE: Temporary fix for semantic token of omnisharp/roslyn not being conform for lsp
                if client.name == "omnisharp" then
                    client.server_capabilities.semanticTokensProvider = {
                        full = vim.empty_dict(),
                        legend = {
                            tokenModifiers = { "static_symbol" },
                            tokenTypes = {
                                "comment",
                                "excluded_code",
                                "identifier",
                                "keyword",
                                "keyword_control",
                                "number",
                                "operator",
                                "operator_overloaded",
                                "preprocessor_keyword",
                                "string",
                                "whitespace",
                                "text",
                                "static_symbol",
                                "preprocessor_text",
                                "punctuation",
                                "string_verbatim",
                                "string_escape_character",
                                "class_name",
                                "delegate_name",
                                "enum_name",
                                "interface_name",
                                "module_name",
                                "struct_name",
                                "type_parameter_name",
                                "field_name",
                                "enum_member_name",
                                "constant_name",
                                "local_name",
                                "parameter_name",
                                "method_name",
                                "extension_method_name",
                                "property_name",
                                "event_name",
                                "namespace_name",
                                "label_name",
                                "xml_doc_comment_attribute_name",
                                "xml_doc_comment_attribute_quotes",
                                "xml_doc_comment_attribute_value",
                                "xml_doc_comment_cdata_section",
                                "xml_doc_comment_comment",
                                "xml_doc_comment_delimiter",
                                "xml_doc_comment_entity_reference",
                                "xml_doc_comment_name",
                                "xml_doc_comment_processing_instruction",
                                "xml_doc_comment_text",
                                "xml_literal_attribute_name",
                                "xml_literal_attribute_quotes",
                                "xml_literal_attribute_value",
                                "xml_literal_cdata_section",
                                "xml_literal_comment",
                                "xml_literal_delimiter",
                                "xml_literal_embedded_expression",
                                "xml_literal_entity_reference",
                                "xml_literal_name",
                                "xml_literal_processing_instruction",
                                "xml_literal_text",
                                "regex_comment",
                                "regex_character_class",
                                "regex_anchor",
                                "regex_quantifier",
                                "regex_grouping",
                                "regex_alternation",
                                "regex_text",
                                "regex_self_escaped_character",
                                "regex_other_escape",
                            },
                        },
                        range = true,
                    }
                end

                local opts = { buffer = bufnr, remap = false }
                -- TODO: Rethink theses mappings
                vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions() end,
                    { desc = 'Telescope goto Definitions' })
                vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set('n', 'gtd', function() require('telescope.builtin').lsp_type_definitions() end,
                    { desc = 'Telescope goto Type Definition' })
                vim.keymap.set('n', 'gi', function() require('telescope.builtin').lsp_implementations() end,
                    { desc = 'Telescope goto Implementation' })
                vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end,
                    { desc = 'Telescope goto References' })
                vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set('n', '<leader>cws', function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set('n', '<leader>cd', function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set('n', '<leader>crn', function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signatue_help() end, opts)
                -- TODO: Fix codelens
                vim.keymap.set('n', '<leader>cl', function() vim.lsp.codelens.run() end)

                -- NOTE: currently unused or defined elsewhere
                -- vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
                -- vim.keymap.set('n', 'gd', function() vim.lsp.buf.definiton() end, opts)
                -- vim.keymap.set('n', 'gi', function () vim.lsp.buf.implementation() end, opts)
            end)

            lsp.set_sign_icons({
                error = '✘',
                warn = '▲',
                hint = '⚑',
                info = '»'
            })

            -- Language servers custom or additional configurations
            -- Lua Language Server
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace"
                        },
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })

            -- C# / OmniSharp
            local datapath = vim.fn.expand("~") .. '\\AppData\\local\\nvim-data'
            require('lspconfig').omnisharp.setup({
                cmd = { 'dotnet', datapath .. '/mason/packages/omnisharp/OmniSharp.dll' },
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
                enable_import_completion = false,
                -- Specifies whether to include preview versions of the .NET SDK when
                -- determining which version to use for project loading.
                sdk_include_prereleases = true,
                -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                -- true
                analyze_open_documents_only = false,
            })

            ---Enable (broadcasting) snippet capability for completion
            -- used for css and json ls
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            -- CSS Config
            require 'lspconfig'.cssls.setup {
                capabilities = capabilities,
            }

            require 'lspconfig'.jsonls.setup {
                capabilities = capabilities,
            }

            -- Angular Language Server
            require 'lspconfig'.angularls.setup {}

            -- ES Lint
            require 'lspconfig'.eslint.setup {}

            -- Typescript Language Server
            require 'lspconfig'.tsserver.setup {}

            lsp.setup()

            -- Additional completion configuration
            local cmp_action = require('lsp-zero').cmp_action()
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
                mapping = {
                    ['<C-f'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b'] = cmp_action.luasnip_jump_backward(),
                }
            })
        end
    },

    -- TODO: Improve this. Lazyness and general search for better option
    -- Prettier for formatting
    {
        "jose-elias-alvarez/null-ls.nvim",
        lazy = false,
        config = function()
            local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
            local event = "BufWritePre" -- or "BufWritePost"
            local async = event == "BufWritePost"

            require("null-ls").setup({
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.keymap.set("n", "<Leader>cf", function()
                            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                        end, { buffer = bufnr, desc = "[lsp] format" })

                        -- format on save
                        -- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                        -- vim.api.nvim_create_autocmd(event, {
                        --     buffer = bufnr,
                        --     group = group,
                        --     callback = function()
                        --         vim.lsp.buf.format({ bufnr = bufnr, async = async })
                        --     end,
                        --     desc = "[lsp] format on save",
                        -- })
                    end

                    if client.supports_method("textDocument/rangeFormatting") then
                        vim.keymap.set("n", "<Leader>cf", function()
                            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                        end, { buffer = bufnr, desc = "[lsp] format" })
                    end
                end,
            })
        end
    },
    {
        "MunifTanjim/prettier.nvim",
        cmd = "Prettier",
        config = function()
            require("prettier").setup({
                bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
                filetypes = {
                    "css",
                    "graphql",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "less",
                    "markdown",
                    "scss",
                    "typescript",
                    "typescriptreact",
                    "yaml",
                },
            })
        end
    }
}
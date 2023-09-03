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

            local opts = { noremap = true, silent = true }
            local on_attach = function(client, bufnr)
                opts.desc = "Show LSP references"
                set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                opts.desc = "Go to declaration"
                set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = "Show LSP definitions"
                set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                opts.desc = "Show LSP implementations"
                set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                opts.desc = "Show LSP type definitions"
                set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                opts.desc = "See available code actions"
                set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = "Smart rename"
                set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = "Show buffer diagnostics"
                set("n", "<leader>vD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                opts.desc = "Show line diagnostics"
                set("n", "<leader>vd", vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = "Go to previous diagnostic"
                set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                opts.desc = "Go to next diagnostic"
                set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                opts.desc = "Show documentation for what is under cursor"
                set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = "Restart LSP"
                set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
            end

            -- used to enable autocompletion (assign to every lsp server config)
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Change the Diagnostic symbols in the sign column (gutter)
            -- TODO: Again put these symbols in own file
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- configure html server
            lspconfig["html"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- configure typescript server with plugin
            lspconfig["tsserver"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- configure css server
            lspconfig["cssls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- configure emmet language server
            lspconfig["emmet_language_server"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
            })

            -- configure lua server (with special settings)
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
                    },
                },
            })

            -- C# / OmniSharp
            local windowsDatapath = vim.fn.expand("~") .. "\\AppData\\local\\nvim-data"
            local linuxDatapath = vim.fn.expand("~") .. "/.local/share/nvim"

            require("lspconfig").omnisharp.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "dotnet", linuxDatapath .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
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
        end,
    },

    -- Show a lightbulb where codeactions are available
    {
        "kosayoda/nvim-lightbulb",
        config = function()
            require("nvim-lightbulb").setup({
                autocmd = { enabled = true },
            })
        end,
    },
}

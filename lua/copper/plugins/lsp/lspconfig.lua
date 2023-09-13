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
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
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

            -- used to enable autocompletion (assign to every lsp server config)
            local capabilities = cmp_nvim_lsp.default_capabilities()
            -- TODO: Maybe this is the correct way -> Check: https://github.com/hrsh7th/cmp-nvim-lsp
            -- lspconfig.util.default_config = vim.tbl_deep_extend("force", lsp.util.default_config, {
            --     capabilities = require("cmp_nvim_lsp").default_capabilities(),
            -- })

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

            lspconfig["angularls"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
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
        event = { "BufEnter", "BufNewFile" },
        config = function()
            require("nvim-lightbulb").setup({
                autocmd = { enabled = true },
                sign = {
                    enabled = true,
                    -- Text to show in the sign column.
                    -- Must be between 1-2 characters.
                    text = "󰌵",
                    -- Highlight group to highlight the sign column text.
                    hl = "LightBulbSign",
                },
            })
        end,
    },
}

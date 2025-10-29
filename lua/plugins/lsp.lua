-- LSP: Language Server Protocol configuration using Neovim 0.11 native APIs

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "b0o/schemastore.nvim", -- JSON/YAML schemas
    },

    config = function()
        -- Diagnostic configuration
        vim.diagnostic.config({
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            virtual_text = false,
            virtual_lines = {
                current_line = true,
            },
            float = {
                border = "rounded",
                source = "always",
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚",
                    [vim.diagnostic.severity.WARN] = "󰀪",
                    [vim.diagnostic.severity.HINT] = "󰌶",
                    [vim.diagnostic.severity.INFO] = "",
                },
            },
        })

        -- LSP floating windows are handled by noice.nvim
        -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
        -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

        -- Custom keymaps on LSP attach
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("config_lsp_attach", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                -- Add custom keymaps (these supplement the built-in grn, gra, grr, etc.)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- Telescope integrations (better UI for references, definitions, etc.)
                if pcall(require, "telescope.builtin") then
                    map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
                    map("n", "gr", "<cmd>Telescope lsp_references<cr>", "Show references")
                    map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Go to implementation")
                    map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", "Go to type definition")
                end

                -- Additional useful keymaps
                map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP Info")
                -- Note: <leader>cf is handled by conform.nvim plugin
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
                map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
                map("n", "<leader>vd", vim.diagnostic.open_float, "Show line diagnostics")

                -- Inlay hints (if supported)
                if client and client.supports_method("textDocument/inlayHint") then
                    map("n", "<leader>uh", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                    end, "Toggle inlay hints")
                end
            end,
        })

        -- Language server configurations using vim.lsp.config()
        local servers = {
            lua_ls = {
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

            ts_ls = {
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayFunctionParameterTypeHints = true,
                        },
                    },
                },
            },

            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            },

            yamlls = {
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = false,
                            url = "",
                        },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            },

            -- Simple servers (use defaults)
            bashls = {},
            cssls = {},
            html = {},
            dockerls = {},
            marksman = {},
            angularls = {},
            emmet_language_server = {},
            eslint = {},
            powershell_es = {},
        }

        -- Configure and enable each server
        for server, config in pairs(servers) do
            vim.lsp.config(server, config)
        end

        -- Enable all configured servers
        vim.lsp.enable(vim.tbl_keys(servers))

        -- Auto-install servers via Mason when it's ready
        -- Map LSP server names to Mason package names (when they differ)
        local server_to_package = {
            ts_ls = "typescript-language-server",
            jsonls = "json-lsp",
            yamlls = "yaml-language-server",
            lua_ls = "lua-language-server",
            bashls = "bash-language-server",
            cssls = "css-lsp",
            html = "html-lsp",
            dockerls = "dockerfile-language-server",
            marksman = "marksman",
            angularls = "angular-language-server",
            emmet_language_server = "emmet-language-server",
            eslint = "eslint-lsp",
            powershell_es = "powershell-editor-services",
        }

        local ensure_installed = vim.tbl_keys(servers)

        -- Check and install missing servers
        local function ensure_servers_installed()
            local registry = require("mason-registry")

            for _, server_name in ipairs(ensure_installed) do
                local package_name = server_to_package[server_name] or server_name

                if not registry.is_installed(package_name) then
                    vim.notify("Installing " .. package_name .. "...", vim.log.levels.INFO)
                    local ok, package = pcall(registry.get_package, package_name)
                    if ok then
                        package:install():once("closed", function()
                            if package:is_installed() then
                                vim.notify(package_name .. " installed successfully", vim.log.levels.INFO)
                            else
                                vim.notify("Failed to install " .. package_name, vim.log.levels.ERROR)
                            end
                        end)
                    else
                        vim.notify("Package " .. package_name .. " not found in Mason registry", vim.log.levels.WARN)
                    end
                end
            end
        end

        -- Wait for Mason registry to load
        if require("mason-registry").refresh then
            require("mason-registry").refresh(ensure_servers_installed)
        else
            ensure_servers_installed()
        end
    end,
}

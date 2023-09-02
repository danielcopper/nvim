return {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jayp0521/mason-null-ls.nvim",
    },
    cmd = "Mason",
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_null_ls = require("mason-null-ls")

        mason.setup({
            ui = {
                -- TODO: Move icons into global spec table
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })

        mason_lspconfig.setup({
            -- list of servers to be installed by mason
            ensure_installed = {
                "angularls",
                "tsserver",
                "html",
                "cssls",
                "lua_ls",
                "emmet_ls",
                "omnisharp"
            },
            -- also auto-install servers that are configured with lspconfig
            automatic_installation = true,
        })

        mason_null_ls.setup({
            -- list of formatters & linters for mason to install
            ensure_installed = {
                "prettierd", -- ts/js formatter
                "stylua", -- lua formatter
                "eslint_d", -- ts/js linter
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true,
        })
    end,
}

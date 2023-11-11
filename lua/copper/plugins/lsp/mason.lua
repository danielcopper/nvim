local icons = require("copper.utils.icons")

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
            -- list of servers to be installed by mason
            ensure_installed = {
                "angularls",
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
                "tsserver",
                "yamlls",
            },
            -- also auto-install servers that are configured with lspconfig
            automatic_installation = true,
        })
    end,
}

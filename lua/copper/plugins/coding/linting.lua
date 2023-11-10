local events = { "BufWritePost", "BufReadPost", "InsertLeave" }

return {
    {
        "mfussenegger/nvim-lint",
        enabled = false,
        event = events,
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                markdown = { "markdownlint" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                yaml = { "yamllint" },
                editorconfig = { "editorconfig-checker" }
            }

            vim.api.nvim_create_autocmd(events, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end
    },
}

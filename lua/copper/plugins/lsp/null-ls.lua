return {
    -- "jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local null_ls = require("null-ls")
        local null_ls_utils = require("null-ls.utils")

        local formatting = null_ls.builtins.formatting   -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters

        -- configure null_ls
        null_ls.setup({
            -- add package.json as identifier for root (for typescript monorepos)
            root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
            -- setup formatters & linters
            sources = {
                --  to disable file types use
                --  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
                -- formatting.stylua, -- lua formatter
                formatting.prettier.with({
                    filetypes = { "markdown" },
                    extra_args = { "--print-width", "80", "--prose-wrap", "always" },
                }),
                diagnostics.eslint_d.with({                                             -- js/ts linter
                    condition = function(utils)
                        return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
                    end,
                }),
                -- Add markdownlint
                diagnostics.markdownlint,
            },
        })
    end,
}

return {
    {
        "stevearc/conform.nvim",
        enabled = false,
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cF",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer with conform",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { { "prettierd", "prettier" } }, -- Use a sub-list to run only the first available formatter
                javascriptreact = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                json = { { "prettierd", "prettier" } },
            },
        },
    },

    {
        "mhartington/formatter.nvim",
        enabled = false,
        event = "BufEnter",
        keys = {
            {
                "<leader>cF",
                "<Cmd>Format<CR>",
                mode = "",
                desc = "Format buffer with formatter.nvim",
            },
        },
        config = function()
            require("formatter").setup({
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    python = { require("formatter.filetypes.python").black, },
                    bash = { require("formatter.filetypes.sh").shfmt, },
                    lua = { require("formatter.filetypes.lua").stylua, },
                    json = { require("formatter.filetypes.json").biome, },
                    javascript = { require("formatter.filetypes.javascript").biome, },
                    typescript = { require("formatter.filetypes.typescript").prettierd, },

                    -- Use the special "*" filetype for defining formatter configurations on any filetype
                    ["*"] = {
                        require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                },
            })
        end
    },
}

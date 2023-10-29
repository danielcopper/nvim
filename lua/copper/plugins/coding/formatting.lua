return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cF",
                -- require("conform").format({ formatters = { "injected" } })
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer with conform",
            },
        },
        -- Everything in opts will be passed to setup()
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                json = { { "prettierd", "prettier" } },
            },
            -- Set up format-on-save
            -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
            -- Customize formatters
            formatters = {
                -- injected = { options = { ignore_errors = true } },
                -- # Example of using dprint only when a dprint.json file is present
                -- dprint = {
                --   condition = function(ctx)
                --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
                --   end,
                -- },
                --
                -- # Example of using shfmt with extra args
                -- shfmt = {
                --   prepend_args = { "-i", "2", "-ci" },
                -- },
            },
        },
        -- init = function()
        --     -- If you want the formatexpr, here is the place to set it
        --     vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        -- end,
    },
}

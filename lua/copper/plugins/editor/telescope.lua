return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- for better sorting performance
        },
        cmd = "Telescope",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,                  -- move to next result in list
                            ["<C-k>"] = actions.move_selection_previous,              -- move to previous result in list
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- send all entries to quickfist list an open it
                        },
                    },
                },
            })

            telescope.load_extension("fzf") -- don't forget to load the performance improvements
        end,
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" } },
            { "<leader>fs", "<cmd>Telescope live_grep<cr>",  { desc = "Fuzzy find string in cwd" } },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   { desc = "Fuzzy find recent files" } },
            {
                "<leader>td",
                function()
                    require("telescope.builtin").diagnostics()
                end,
                { desc = "Lists diagnostics for currently open buffers in Telescope" },
            },
            {
                "<leader>km",
                function()
                    require("telescope.builtin").keymaps()
                end,
                { desc = "Lists normal mode keymappings in Telescope" },
            },
            {
                "<leader>tn",
                function()
                    require("telescope").extensions.notify.notify()
                end,
                { desc = "Show all Notifications in Telescope" },
            },
            { "<leader>tt", "<Cmd>TodoTelescope<CR>",             { desc = "Open Todos in Telescope" } },
            { "<leader>th", "<cmd>Telescope command_history<cr>", desc = "Telescope Command History" },
            { "<leader>tc", "<cmd>Telescope commands<cr>",        desc = "Telesecope Commands" },
            { "<leader>tm", "<cmd>Telescope man_pages<cr>",       desc = "Telescope Man Pages" },
            -- TODO: implement utility functions
            -- { "<leader>tC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
            {
                "<leader>ts",
                function()
                    require("telescope.builtin").lsp_document_symbols({
                        symbols = require("lazyvim.config").get_kind_filter(),
                    })
                end,
                desc = "Goto Symbol",
            },
        },
    },
}


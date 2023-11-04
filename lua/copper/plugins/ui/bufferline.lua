local icons = require("copper.plugins.extras.icons")

return {
    -- Bufferline (the tabs on top)
    {
        enabled = true,
        event = "VeryLazy",
        --lazy = false,
        "akinsho/nvim-bufferline.lua",
        opts = {
            options = {
                mode = "buffers", -- set to "tabs" to only show tabpages instead
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        separator = true,
                        text_align = "center"
                    },
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        separator = true,
                        text_align = "center"
                    },
                },
                -- indicator = {
                --     style = 'underline'
                -- },
                separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
                show_tab_indicators = true,
                diagnostics = "nvim_lsp",
                --- count is an integer representing total count of errors
                --- level is a string "error" | "warning"
                --- diagnostics_dict ij a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
                --- this should return a string
                --- Don't get too fancy as this function will be executed a lot
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local icon = level:match("error") and icons.diagnostics.Error or icons.diagnostics.Warning
                    return " " .. icon .. count
                end,
                color_icons = true,
                show_buffer_icons = true,
            },
        },
        config = function(_, opts)
            require("bufferline").setup(opts)
            require("bufdel").setup({
                quit = false, -- quit Neovim when last buffer is closed
            })
        end,
        keys = {
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>",    { desc = "Move to Prev buffer" } },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>",    { desc = "Move to Next buffer" } },
            { "<A-,>", "<Cmd>BufferLineCyclePrev<CR>",    { desc = "Move to Prev buffer", remap = true } },
            { "<A-.>", "<Cmd>BufferLineCycleNext<CR>",    { desc = "Move to Next buffer", remap = true } },
            { "<A-<>", "<Cmd>BufferLineMovePrevious<CR>", { desc = "Move buffer to the left" } },
            { "<A->>", "<Cmd>BufferLineMoveNext<CR>",     { desc = "Move Buffer to the right" } },
            { "<A-1>", "<Cmd>BufferLineGoTo 1<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-2>", "<Cmd>BufferLineGoTo 2<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-3>", "<Cmd>BufferLineGoTo 3<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-4>", "<Cmd>BufferLineGoTo 4<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-5>", "<Cmd>BufferLineGoTo 5<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-6>", "<Cmd>BufferLineGoTo 6<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-7>", "<Cmd>BufferLineGoTo 7<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-8>", "<Cmd>BufferLineGoTo 8<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-9>", "<Cmd>BufferLineGoTo 9<CR>",       { desc = "Goto Buffer number 9" } },
            { "<A-p>", "<Cmd>BufferLineTogglePin<CR>",    { desc = "Pin current Buffer" } },
            { "<C-p>", "<Cmd>BufferLineGoToBuffer<CR>",   { desc = "Pick Buffer to jump to" } },
            -- {'<A-c>', '<Cmd>:b#|bd#<CR>', { desc = 'Close current Buffer' }},
            { "<A-c>", "<Cmd>BufDel<CR>",                 { desc = "Close current Buffer" } },
            {
                "<leader>bca",
                "<C-w>h <bar> <Cmd>BufDelOthers<CR>",
                { desc = "Close all Buffers but File Explorer" },
            },
            { "<leader>bcA", "<Cmd>BufDelAll<CR>",                      { desc = "Close all Buffers" } },
            { "<leader>bco", "<Cmd>BufDelOthers<CR>",                   { desc = "Close all but current Buffer" } },
            { "<leader>bcu", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Close unpinned Buffers" } },
        },
    },
}

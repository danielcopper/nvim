return {
    enabled = true,
    lazy = false,
    'akinsho/nvim-bufferline.lua',
    -- init = function()
    --     -- NOTE: Bufferline relies on termguicolors to be loaded before itself
    --     vim.opt.termguicolors = true
    -- end,
    opts = {
        options = {
            mode = 'buffers', -- set to "tabs" to only show tabpages instead
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = 'File Explorer',
                    padding = 1
                }
            },
            -- indicator = {
            --     style = 'underline'
            -- },
            separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
            show_tab_indicators = true,
            diagnostics = 'nvim_lsp',
            --- count is an integer representing total count of errors
            --- level is a string "error" | "warning"
            --- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
            --- this should return a string
            --- Don't get too fancy as this function will be executed a lot
            diagnostics_indicator = function(count, level)
                local icon = level:match("error") and " " or ""
                return " " .. icon .. count
            end,
            color_icons = true,
            show_buffer_icons = true
        }
    },
    keys = {
        vim.keymap.set('n', '<A-,>', '<Cmd>BufferLineCyclePrevious<CR>'),
        vim.keymap.set('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>'),
        vim.keymap.set('n', '<A-<>', '<Cmd>BufferLineMovePrevious<CR>'),
        vim.keymap.set('n', '<A->>', '<Cmd>BufferLineMoveNext<CR>'),
        vim.keymap.set('n', '<A-1>', '<Cmd>BufferLineGoTo 1<CR>'),
        vim.keymap.set('n', '<A-2>', '<Cmd>BufferLineGoTo 2<CR>'),
        vim.keymap.set('n', '<A-3>', '<Cmd>BufferLineGoTo 3<CR>'),
        vim.keymap.set('n', '<A-4>', '<Cmd>BufferLineGoTo 4<CR>'),
        vim.keymap.set('n', '<A-5>', '<Cmd>BufferLineGoTo 5<CR>'),
        vim.keymap.set('n', '<A-6>', '<Cmd>BufferLineGoTo 6<CR>'),
        vim.keymap.set('n', '<A-7>', '<Cmd>BufferLineGoTo 7<CR>'),
        vim.keymap.set('n', '<A-8>', '<Cmd>BufferLineGoTo 8<CR>'),
        vim.keymap.set('n', '<A-9>', '<Cmd>BufferLineGoTo 9<CR>'),
        vim.keymap.set('n', '<A-p>', '<Cmd>BufferLineTogglePin<CR>'),
        -- NOTE: Closes the current Buffer and opens the previous one
        vim.keymap.set('n', '<A-c>', '<Cmd>:b#|bd#<CR>'),
        vim.keymap.set('n', '<C-p>', '<Cmd>BufferLineGoToBuffer<CR>'),
    },
}

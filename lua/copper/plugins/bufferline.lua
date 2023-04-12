return {
    enabled = true,
    lazy = false,
    'akinsho/nvim-bufferline.lua',
    opts = {
        options = {
            mode = 'buffers', -- set to "tabs" to only show tabpages instead
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = 'File Explorer',
                    padding = 1,
                    separator = false
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
    dependencies = {
        'ojroques/nvim-bufdel',
    },
    config = function(_, opts)
        require('bufferline').setup(opts)
        require('bufdel').setup({
            quit = false -- quit Neovim when last buffer is closed
        })
    end,
    keys = {
        vim.keymap.set('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Select previous Buffer' }),
        vim.keymap.set('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Select next Buffer' }),
        vim.keymap.set('n', '<A-<>', '<Cmd>BufferLineMovePrevious<CR>', { desc = 'Move buffer to the left' }),
        vim.keymap.set('n', '<A->>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Move Buffer to the right' }),
        vim.keymap.set('n', '<A-1>', '<Cmd>BufferLineGoTo 1<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-2>', '<Cmd>BufferLineGoTo 2<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-3>', '<Cmd>BufferLineGoTo 3<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-4>', '<Cmd>BufferLineGoTo 4<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-5>', '<Cmd>BufferLineGoTo 5<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-6>', '<Cmd>BufferLineGoTo 6<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-7>', '<Cmd>BufferLineGoTo 7<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-8>', '<Cmd>BufferLineGoTo 8<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-9>', '<Cmd>BufferLineGoTo 9<CR>', { desc = 'Goto Buffer number 9' }),
        vim.keymap.set('n', '<A-p>', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Pin current Buffer' }),
        vim.keymap.set('n', '<C-p>', '<Cmd>BufferLineGoToBuffer<CR>', { desc = 'Pick Buffer to jump to' }),
        -- NOTE: Closes the current Buffer and opens the previous one
        -- vim.keymap.set('n', '<A-c>', '<Cmd>:b#|bd#<CR>', { desc = 'Close current Buffer' }),
        vim.keymap.set('n', '<A-c>', '<Cmd>BufDel<CR>', { desc = 'Close current Buffer' }),
        vim.keymap.set('n', '<leader>ca', '<Cmd>BufDelAll<CR>', { desc = 'Close all Buffers' }),
        vim.keymap.set('n', '<leader>co', '<Cmd>BufDelOthers<CR>', { desc = 'Close all but current Buffer' }),
        -- vim.keymap.set('n', '<leader>co', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Close unpinned Buffers' }),
        -- vim.keymap.set('n', '<leader>ca',
        --     function()
        --         for _, e in ipairs(bufferline.get_elements().elements) do
        --             vim.schedule(function()
        --                 vim.cmd("bd " ..
        --                     e.id)
        --             end)
        --         end
        --     end, { desc = 'Close all Buffers' }),
    },
}

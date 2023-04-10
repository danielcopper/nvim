return {
    'romgrk/barbar.nvim',
    enabled = false,
    init = function() vim.g.barbar_auto_setup = false end,
    lazy = false,
    opts = {
        -- Enable/disable animations
        animation = true,
        -- Enable/disable auto-hiding the tab bar when there is a single buffer
        auto_hide = false,
        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,
        -- Enables/disable clickable tabs
        --  - left-click: go to buffer
        --  - middle-click: delete buffer
        clickable = true,
        -- Excludes buffers from the tabline
        -- exclude_ft = { 'javascript' },
        -- exclude_name = { 'package.json' },
        -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
        -- Valid options are 'left' (the default) and 'right'
        focus_on_close = 'left',
        -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
        -- hide = { extensions = true, inactive = true },
        -- Disable highlighting alternate buffers
        highlight_alternate = false,
        -- Disable highlighting file icons in inactive buffers
        highlight_inactive_file_icons = false,
        -- Enable highlighting visible buffers
        highlight_visible = true,
        icons = {
            -- Configure the base icons on the bufferline.
            buffer_index = false,
            buffer_number = false,
            button = '',
            -- Enables / disables diagnostic symbols
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
                [vim.diagnostic.severity.WARN] = { enabled = false },
                [vim.diagnostic.severity.INFO] = { enabled = false },
                [vim.diagnostic.severity.HINT] = { enabled = false },
            },
            filetype = {
                -- Sets the icon's highlight group.
                -- If false, will use nvim-web-devicons colors
                custom_colors = false,
                -- Requires `nvim-web-devicons` if `true`
                enabled = true,
            },
            separator = { left = '▎', right = '' },
            -- Configure the icons on the bufferline when modified or pinned.
            -- Supports all the base icon options.
            modified = { button = '●' },
            pinned = { button = '車' },
            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            alternate = { filetype = { enabled = false } },
            current = { buffer_index = true },
            inactive = { button = '×' },
            visible = { modified = { buffer_number = false } },
        },
        -- If true, new buffers will be inserted at the start/end of the list.
        -- Default is to insert after current buffer.
        insert_at_end = false,
        insert_at_start = true,
        -- Sets the maximum padding width with which to surround each tab
        maximum_padding = 1,
        -- Sets the minimum padding width with which to surround each tab
        minimum_padding = 1,
        -- Sets the maximum buffer name length.
        maximum_length = 30,
        -- If set, the letters for each buffer in buffer-pick mode will be
        -- assigned based on their name. Otherwise or in case all letters are
        -- already assigned, the behavior is to assign letters in order of
        -- usability (see order below)
        semantic_letters = true,
        -- Set the filetypes which barbar will offset itself for
        sidebar_filetypes = {
            -- Use the default values: {event = 'BufWinLeave', text = nil}
            NvimTree = true,
            -- Or, specify the text used for the offset:
            undotree = { text = 'undotree' },
            -- Or, specify the event which the sidebar executes when leaving:
            -- ['neo-tree'] = { event = 'BufWipeout' },
            -- Or, specify both
            -- Outline = { event = 'BufWinLeave', text = 'symbols-outline' },
        },
        -- New buffer letters are assigned in this order. This order is
        -- optimal for the qwerty keyboard layout but might need adjustement
        -- for other layouts.
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
        -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
        -- where X is the buffer number. But only a static string is accepted here.
        no_name_title = nil,
    },
    keys = {
        -- Move to previous/next
        vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>'),
        vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>'),
        -- Re-order to previous/next
        vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>'),
        vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>'),
        -- Goto buffer in position...
        vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>'),
        vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>'),
        vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>'),
        vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>'),
        vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>'),
        vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>'),
        vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>'),
        vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>'),
        vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>'),
        vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>'),
        -- Pin/unpin buffer
        vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>'),
        -- Close buffer
        vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>'),
        -- Wipeout buffer
        --                 :BufferWipeout
        -- Close commands
        --                 :BufferCloseAllButCurrent
        --                 :BufferCloseAllButPinned
        --                 :BufferCloseAllButCurrentOrPinned
        --                 :BufferCloseBuffersLeft
        --                 :BufferCloseBuffersRight
        -- Magic buffer-picking mode
        vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>'),
        -- Sort automatically by...
        vim.keymap.set('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>'),
        vim.keymap.set('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>'),
        vim.keymap.set('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>'),
        vim.keymap.set('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>'),
    },
}

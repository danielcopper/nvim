return {
    'akinsho/toggleterm.nvim',
    config = function()
        local powershell_options = {
            shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
            shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
            shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
            shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
            shellquote = "",
            shellxquote = "",
        }
        -- this maps the Esc key so that the terminal actually looses focus and the toggle works inside the terminal
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

        -- window movement wenn in terminal
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])

        -- opening different terminals
        vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t1", ":1ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>ta", ":ToggleTermToggleAll<CR>")
        vim.keymap.set("n", "<leader>tg", ":lua Lazygit_toggle()<CR>")

        for option, value in pairs(powershell_options) do
            vim.opt[option] = value
        end

        require('toggleterm').setup({
            insert_mappings = true,
            size = 30,
            shell = "powershell",
            insert_mappings = true,
        })

        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit  = Terminal:new({
            cmd = 'lazygit',
            hidden = true,
            start_in_insert = false,
            dir = 'git_dir',
            direction = 'float',
            float_opts = {
                border = { '╒', '═', '╕', '│', '╛', '═', '╘', '│' },
                width = 150,
                height = 40
            },
            -- function to run on opening the terminal
            on_open = function(term)
                vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>',
                    { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<esc>', '<cmd>close<CR>',
                    { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<C-\\>', '<cmd>close<CR>',
                    { noremap = true, silent = true })
            end
        })

        function Lazygit_toggle()
            lazygit:toggle()
        end

        vim.cmd [[ command Git lua Lazygit_toggle()<CR> ]]
    end
}

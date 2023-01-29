return {
    'akinsho/toggleterm.nvim',
    init = function()
        -- this maps the Esc key so that the terminal actually looses focus and the toggle works inside the terminal
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])

        -- window movement wenn in terminal
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])

        vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t1", ":1ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>ta", ":ToggleTermToggleAll<CR>")
    end,
    config = function()
        local powershell_options = {
            shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
            shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
            shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
            shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
            shellquote = "",
            shellxquote = "",
        }

        for option, value in pairs(powershell_options) do
            vim.opt[option] = value
        end

        require('toggleterm').setup({
            insert_mappings = true,
            size = 30,
            shell = "powershell",
            insert_mappings = true,
        })
    end
}

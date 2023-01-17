return {
    'akinsho/toggleterm.nvim',
    init = function()
        vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>t2", ":2ToggleTerm<CR>")
        vim.keymap.set("n", "<leader>ta", ":ToggleTermToggleAll<CR>")

        -- this maps the Esc key so that the terminal actually looses focus and the toggle works inside the terminal
        vim.cmd([[ tmap <Esc> <c-\><c-n> ]])
    end,
    config = function()
        require('toggleterm').setup({
            size = 40,
            shell = "pwsh"
        })
    end
}

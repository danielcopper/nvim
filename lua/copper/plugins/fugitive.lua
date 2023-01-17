return {
    'tpope/vim-fugitive',
    config = function()
        -- gs for Git Status
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end
}

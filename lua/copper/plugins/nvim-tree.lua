return {
    'nvim-tree/nvim-tree.lua',
    init = function()
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>")
        vim.keymap.set("n", "<leader>er", ":NvimTreeRefresh<CR>")
    end,
    config = function()
        require("nvim-tree").setup({
            git = {
                ignore = false,
            },
            view = {
                width = 35,
            },
            renderer = {
                full_name = true,
                root_folder_label = ':t'
            }
        })
    end
}

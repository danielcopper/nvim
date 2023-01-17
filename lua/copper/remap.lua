-- custom remaps that are unrelated to a specific package
-- This one is to map the leader key to <space>
vim.g.mapleader = " "

-- This one is to open netrw faster
-- currently unused since NvimTree handles file exploring
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>pv", ":Ex<CR>")

-- J and K allow text thats selected to be moved in bulk
-- includes auto indent -> awesome =O
vim.keymap.set("v", "J", ":m '<+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")

-- When appending the line the cursor stays in place
vim.keymap.set("n", "J", "mzJ`z")

-- scroll while keeping cursor in the middle of the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keeps the cursor in the middle while jumping between search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- this allows to paste over without loosing the buffering
-- no more loosing the buffer while deleting - yay
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
-- allows to yank into the system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- delete into system clipboard
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- never use capital q
vim.keymap.set("n", "Q", "<nop>")

-- TODO - test this -> not working needs research
-- should help switching fast between project when pressing ctrl-f
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quick formatting
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

-- TODO - need testing. probably not working
-- related to the quick fix list -> do some research
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- complicated but awesome!
-- replaces the word the cursor is currently on
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- Linux related -> make a file executable
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

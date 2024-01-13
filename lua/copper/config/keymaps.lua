vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>", { desc = "Show Undotree" })
vim.keymap.set("n", "Y", "yg$", { desc = "Yank till the end of the line" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Keep the cursor in line when appending the line below" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scrolling down keeps the cursor in the middle of the screen" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scrolling up keeps the cursor in the middle of the screen" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Jumping to the next result keeps the cursor in the middle of the screen" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jumping to the previous result keeps the cursor in the middle of the screen" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank into system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank into system clipboard" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete into system clipboard" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Prevent from using capital Q" })
vim.keymap.set( "n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search and Replace the String under the cursor for the current file" })

vim.keymap.set("v", "J", ":m '<+1<CR>gv=gv", { desc = "Move selected text bulk down and indent" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text bulk up and indent" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank into system clipboard" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete into system clipboard" })

vim.keymap.set("x", "<leader>p", "'_dP", { desc = "Allows to paste over without loosing the buffer" })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- for exiting terminal mode
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

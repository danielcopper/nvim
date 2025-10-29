-- Keymaps (Leader: Space, Local Leader: \)

local keymap = vim.keymap.set

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Better scrolling (keep cursor centered)
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Visual mode: stay in indent mode
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Visual mode: move text up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste without yanking in visual mode
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Better editing
keymap("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
keymap("n", "Y", "y$", { desc = "Yank to end of line" })

-- System clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole register" })

-- Search and replace word under cursor
keymap("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Buffer navigation
-- <leader>bd is handled by snacks.nvim bufdelete
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Quick buffer access with Alt+number
for i = 1, 9 do
  keymap("n", "<A-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer " .. i })
end

-- Quick save/quit
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Disable Ex mode
keymap("n", "Q", "<nop>")

-- Terminal mode: easier exit
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

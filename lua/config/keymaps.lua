local keymap = vim.keymap.set

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- Window resizing
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
keymap({ "n", "t" }, "<M-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap({ "n", "t" }, "<M-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
keymap({ "n", "t" }, "<M-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap({ "n", "t" }, "<M-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap({ "n", "t" }, "<M-z>", function()
  if vim.g._zoom_restore_cmd then
    vim.cmd(vim.g._zoom_restore_cmd)
    vim.g._zoom_restore_cmd = nil
  else
    vim.g._zoom_restore_cmd = vim.fn.winrestcmd()
    vim.cmd("wincmd |")
  end
end, { desc = "Toggle zoom window" })

-- Better scrolling (keep cursor centered)
-- NOTE: These are handled as long as mini.animate is enabled
-- keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
-- keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Visual mode: stay in indent mode
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Visual mode: move text up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better editing
keymap("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
keymap("n", "Y", "y$", { desc = "Yank to end of line" })

-- System clipboard
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Search and replace word under cursor
keymap("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Buffer navigation
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Quick save/quit
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Disable Ex mode
keymap("n", "Q", "<nop>")

-- Git / Worktree
keymap("n", "<leader>gg", function() require("worktree").lazygit() end, { desc = "LazyGit" })
keymap("n", "<leader>gw", function() require("worktree").pick() end, { desc = "Switch worktree" })

-- Theme controls
keymap("n", "<leader>ut", function()
  vim.g.transparent_bg = not vim.g.transparent_bg
  vim.cmd("colorscheme " .. vim.g.colors_name)
  vim.notify("Transparency: " .. (vim.g.transparent_bg and "ON" or "OFF"))
end, { desc = "Toggle transparency" })

-- Neovim package manager (vim.pack)
keymap("n", "<leader>nu", function() vim.pack.update() end, { desc = "Pack update" })
keymap("n", "<leader>ns", function() vim.print(vim.pack.get()) end, { desc = "Pack status" })

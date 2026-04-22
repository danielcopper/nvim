vim.pack.add({ "https://github.com/coder/claudecode.nvim" })

require("claudecode").setup({
  auto_start = true,
  log_level = "info",

  terminal = {
    provider = "native",
    split_side = "right",
    split_width_percentage = 0.35,
    auto_close = false,
  },

  diff_opts = {
    layout = "vertical",
    open_in_new_tab = true,
    keep_terminal_focus = true,
    hide_terminal_in_new_tab = false,
  },

  git_repo_cwd = true,
})

-- Hide Claude terminal from buffer lists
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*claude*",
  callback = function()
    vim.bo.buflisted = false
    vim.wo.winfixwidth = true
  end,
  desc = "Unlist Claude terminal",
})

-- Always keep Claude terminal in insert mode
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "term://*claude*",
  callback = function()
    vim.cmd("startinsert")
  end,
  desc = "Auto-insert Claude terminal",
})

-- Neo-tree integration: <leader>as adds the file under cursor to Claude context
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.keymap.set("n", "<leader>as", function()
      local state = require("neo-tree.sources.manager").get_state("filesystem")
      local node = state.tree:get_node()
      if node and node.path then
        vim.cmd("ClaudeCodeAdd " .. node.path)
        vim.notify("Added to Claude: " .. vim.fn.fnamemodify(node.path, ":t"), vim.log.levels.INFO)
      end
    end, { buffer = true, desc = "Add to Claude Context" })
  end,
})

-- Keymaps
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
vim.keymap.set({ "n", "v" }, "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude Code" })
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude Model" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCodeRestart<cr>", { desc = "Restart Claude Server" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send Selection to Claude" })
vim.keymap.set("n", "<leader>aa", function()
  local file = vim.fn.expand("%:p")
  if file ~= "" then
    vim.cmd("ClaudeCodeAdd " .. file)
    vim.notify("Added " .. vim.fn.expand("%:t") .. " to Claude context", vim.log.levels.INFO)
  else
    vim.notify("No file to add", vim.log.levels.WARN)
  end
end, { desc = "Add Current File to Claude" })
vim.keymap.set("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept/Yes Diff" })
vim.keymap.set("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny/No Diff" })

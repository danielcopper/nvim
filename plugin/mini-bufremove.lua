vim.pack.add({ "https://github.com/echasnovski/mini.bufremove" })

-- No setup() call required — mini.bufremove exposes delete() directly.

local br = function() return require("mini.bufremove") end

vim.keymap.set("n", "<leader>bd", function() br().delete(0, false) end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", function() br().delete(0, true) end, { desc = "Delete buffer (force)" })
vim.keymap.set("n", "<leader>bda", function()
  local d = br()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then d.delete(buf, false) end
  end
end, { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bdo", function()
  local d = br()
  local cur = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and buf ~= cur then d.delete(buf, false) end
  end
end, { desc = "Delete other buffers" })

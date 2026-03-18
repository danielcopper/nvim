-- Mini.bufremove: Delete buffers without closing windows

return {
  "echasnovski/mini.bufremove",
  keys = {
    { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete buffer" },
    { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete buffer (force)" },
    { "<leader>bda", function()
      local br = require("mini.bufremove")
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted then br.delete(buf, false) end
      end
    end, desc = "Delete all buffers" },
    { "<leader>bdo", function()
      local br = require("mini.bufremove")
      local cur = vim.api.nvim_get_current_buf()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted and buf ~= cur then br.delete(buf, false) end
      end
    end, desc = "Delete other buffers" },
  },
}

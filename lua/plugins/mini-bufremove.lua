-- Mini.bufremove: Delete buffers without closing windows

return {
  "echasnovski/mini.bufremove",
  keys = {
    { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete buffer" },
    { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete buffer (force)" },
  },
}

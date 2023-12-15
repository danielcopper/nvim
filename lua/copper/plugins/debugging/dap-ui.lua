return {
  "rcarriga/nvim-dap-ui",
  dependencies = "mfussenegger/nvim-dap",
  keys = {
    { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
  },
  opts = {
    icons = {
      expanded = "󰅀",
      collapsed = "󰅂",
      current_frame = "󰅂",
    },
  },
  config = function(_, opts)
    local dap, dapui = require("dap"), require("dapui")

    -- Open and Close windows automatically
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    dapui.setup(opts)
  end,
}

-- DAP: Debug Adapter Protocol for debugging

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end,     desc = "Run to cursor" },
    { "<leader>ds", function() require("dap").step_over() end,         desc = "Step over" },
    { "<leader>di", function() require("dap").step_into() end,         desc = "Step into" },
    { "<leader>do", function() require("dap").step_out() end,          desc = "Step out" },
    { "<leader>dt", function() require("dap").terminate() end,         desc = "Terminate" },
    { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle DAP UI" },

    { "<F5>",       function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
    { "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step over" },
    { "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step into" },
    { "<S-F11>",    function() require("dap").step_out() end,          desc = "Debug: Step out" },
  },

  init = function()
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine", numhl = "" })
  end,

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      -- floating = {
      --   border = "rounded",
      -- },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- DAP adapters are automatically installed via mason-packages.lua
    dap.adapters.coreclr = {
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dap.adapters.netcoredbg = {
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
      },
      {
        type = "coreclr",
        name = "attach - netcoredbg",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }
  end,
}

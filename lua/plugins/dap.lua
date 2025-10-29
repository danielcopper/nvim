-- DAP: Debug Adapter Protocol for debugging

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
  },
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
    { "<leader>ds", function() require("dap").step_over() end, desc = "Step over" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },

    -- Standard IDE debugging keybindings
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step into" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step out" },
  },

  init = function()
    -- Define signs immediately (before DAP fully loads)
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine", numhl = "" })
  end,

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup DAP UI
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      floating = {
        border = "rounded",
      },
    })

    -- Auto-open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Auto-install netcoredbg via Mason
    local function ensure_netcoredbg_installed()
      local mason_registry = require("mason-registry")

      if not mason_registry.is_installed("netcoredbg") then
        vim.notify("Installing netcoredbg...", vim.log.levels.INFO)
        local ok, netcoredbg = pcall(mason_registry.get_package, "netcoredbg")
        if ok then
          netcoredbg:install():once("closed", function()
            if netcoredbg:is_installed() then
              vim.notify("netcoredbg installed successfully", vim.log.levels.INFO)
            else
              vim.notify("Failed to install netcoredbg", vim.log.levels.ERROR)
            end
          end)
        else
          vim.notify("netcoredbg package not found in Mason registry", vim.log.levels.WARN)
        end
      end
    end

    -- Wait for Mason registry to load
    local mason_registry = require("mason-registry")
    if mason_registry.refresh then
      mason_registry.refresh(ensure_netcoredbg_installed)
    else
      ensure_netcoredbg_installed()
    end

    -- .NET Core debugger configuration
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

    -- .NET Core configurations
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

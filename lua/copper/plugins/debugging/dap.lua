return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- TODO: Find out how to add prelaunch tasks
    -- Runs preLaunchTasks if present
    "stevearc/overseer.nvim",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
  },
  keys = {
    { "<F4>",        "<CMD>DapTerminate<CR>",                                                              desc = "DAP Terminate" },
    {
      "<F5>",
      function()
        -- (Re-)reads launch.json if present
        if vim.fn.filereadable(".vscode/launch.json") then
          require("dap.ext.vscode").load_launchjs(nil, {
            ["codelldb"] = { "c", "cpp" },
            ["pwa-node"] = { "typescript", "javascript" },
          })
        end
        require("dap").continue()
      end,
      desc = "DAP Continue",
    },
    { "<F6>",        function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
    { "<F7>",        function() require("dap").goto_() end,                                                desc = "Go to line (skip)" },
    { "<F9>",        "<CMD>DapToggleBreakpoint<CR>",                                                       desc = "Toggle Breakpoint" },
    { "<leader>tb",  "<CMD>DapToggleBreakpoint<CR>",                                                       desc = "Toggle Breakpoint" },
    { "<leader>tcb", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition", },
    { "<F10>",       "<CMD>DapStepOver<CR>",                                                               desc = "Step Over" },
    { "<F11>",       "<CMD>DapStepInto<CR>",                                                               desc = "Step Into" },
    { "<F12>",       "<CMD>DapStepOut<CR>",                                                                desc = "Step Out" },
  },
  config = function()
    local dap = require("dap")

    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(require("copper.utils.icons").dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
  end,
}

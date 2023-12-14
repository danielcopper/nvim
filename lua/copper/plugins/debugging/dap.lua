-- TODO: Turn into proper functions (maybe into utils)
vim.g.dotnet_build_project = function()
  local default_path = vim.fn.getcwd() .. '/'
  if vim.g['dotnet_last_proj_path'] ~= nil then
    default_path = vim.g['dotnet_last_proj_path']
  end
  local path = vim.fn.input('Path to your *proj file: ', default_path, 'file')
  vim.g['dotnet_last_proj_path'] = path
  -- local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
  local cmd = 'dotnet build'
  print('')
  print('Cmd to execute: ' .. cmd)
  local f = os.execute(cmd)
  if f == 0 then
    print('\nBuild: ✔️ ')
  else
    print('\nBuild: ❌ (code: ' .. f .. ')')
  end
end

vim.g.dotnet_get_dll_path = function()
  local request = function()
    return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
  end

  if vim.g['dotnet_last_dll_path'] == nil then
    vim.g['dotnet_last_dll_path'] = request()
  else
    if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
      vim.g['dotnet_last_dll_path'] = request()
    end
  end

  return vim.g['dotnet_last_dll_path']
end


return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- TODO: Find out how to add prelaunch tasks
    -- Runs preLaunchTasks if present
    "stevearc/overseer.nvim", -- is configured somewhere else
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
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

    -- C#
    -- dap.adapters.coreclr = {
    --   type = 'executable',
    --   -- TODO: Test this path on linux
    --   command = vim.fn.stdpath('data') .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
    --   -- command = vim.fn.stdpath('data') .. '/mason/bin/netcoredbg',
    --   args = { '--interpreter=vscode' }
    -- }
    -- dap.configurations.cs = {
    --   {
    --     type = "coreclr",
    --     name = "launch - netcoredbg",
    --     request = "launch",
    --     program = function() -- Ask the user what executable wants to debug
    --       return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net8.0/', 'file')
    --     end,
    --   },
    -- }
    -- -- Visual basic dotnet
    -- dap.configurations.vb = dap.configurations.cs
    -- local config = {
    --   {
    --     type = "coreclr",
    --     name = "launch - netcoredbg",
    --     request = "launch",
    --     program = function()
    --       -- TODO: This might be the place to use compiler for handling the build
    --       if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
    --         vim.g.dotnet_build_project()
    --       end
    --       return vim.g.dotnet_get_dll_path()
    --     end,
    --   },
    -- }

    -- dap.configurations.cs = config
    -- dap.configurations.fsharp = config

    -- Lua
    dap.adapters.nlua = function(callback, config)
      callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
        program = function() pcall(require "osv".launch({ port = 8086 })) end,
      }
    }

    -- Javascript / Typescript (firefox)
    dap.adapters.firefox = {
      type = 'executable',
      command = vim.fn.stdpath('data') .. '/mason/bin/firefox-debug-adapter',
    }
    dap.configurations.typescript = {
      {
        name = 'Debug with Firefox',
        type = 'firefox',
        request = 'launch',
        reAttach = true,
        url = 'http://localhost:4200', -- Write the actual URL of your project.
        webRoot = '${workspaceFolder}',
        firefoxExecutable = '/usr/bin/firefox'
      }
    }
    dap.configurations.javascript = dap.configurations.typescript
    dap.configurations.javascriptreact = dap.configurations.typescript
    dap.configurations.typescriptreact = dap.configurations.typescript

    -- Javascript / Typescript (chromium)
    -- If you prefer to use this adapter, comment the firefox one.
    -- But to use this adapter, you must manually run one of these two, first:
    -- * chromium --remote-debugging-port=9222 --user-data-dir=remote-profile
    -- * google-chrome-stable --remote-debugging-port=9222 --user-data-dir=remote-profile
    -- After starting the debugger, you must manually reload page to get all features.
    -- dap.adapters.chrome = {
    --  type = 'executable',
    --  command = vim.fn.stdpath('data')..'/mason/bin/chrome-debug-adapter',
    -- }
    -- dap.configurations.typescript = {
    --  {
    --   name = 'Debug with Chromium',
    --   type = "chrome",
    --   request = "attach",
    --   program = "${file}",
    --   cwd = vim.fn.getcwd(),
    --   sourceMaps = true,
    --   protocol = "inspector",
    --   port = 9222,
    --   webRoot = "${workspaceFolder}"
    --  }
    -- }
    -- dap.configurations.javascript = dap.configurations.typescript
    -- dap.configurations.javascriptreact = dap.configurations.typescript
    -- dap.configurations.typescriptreact = dap.configurations.typescript

    -- Shell
    dap.adapters.bashdb = {
      type = 'executable',
      command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
      name = 'bashdb',
    }
    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = "Launch file",
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
        pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
        trace = true,
        file = "${file}",
        program = "${file}",
        cwd = '${workspaceFolder}',
        pathCat = "cat",
        pathBash = "/bin/bash",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        args = {},
        env = {},
        terminalKind = "integrated",
      }
    }
  end,
}

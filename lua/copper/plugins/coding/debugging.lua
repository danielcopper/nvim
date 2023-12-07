return {
  {
    "mfussenegger/nvim-dap",
    event = "User BaseFile",
    config = function(_, opts)
      local dap = require("dap")

      -- C#
      dap.adapters.coreclr = {
        type = 'executable',
        command = vim.fn.stdpath('data') .. '/mason/bin/netcoredbg',
        args = { '--interpreter=vscode' }
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function() -- Ask the user what executable wants to debug
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Program.exe', 'file')
          end,
        },
      }
      -- Visual basic dotnet
      dap.configurations.vb = dap.configurations.cs

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
    end, -- of dap config
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        "jbyuki/one-small-step-for-vimkind",
        "mfussenegger/nvim-jdtls",
        dependencies = { "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = { handlers = {} },
      },
      {
        "rcarriga/nvim-dap-ui",
        opts = { floating = { border = "rounded" } },
        config = function(_, opts)
          local dap, dapui = require "dap", require "dapui"
          dap.listeners.after.event_initialized["dapui_config"] = function(
          )
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function(
          )
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
          dapui.setup(opts)
        end,
      },
      {
        "rcarriga/cmp-dap",
        dependencies = { "nvim-cmp" },
        config = function()
          require("cmp").setup.filetype(
            { "dap-repl", "dapui_watches", "dapui_hover" },
            {
              sources = {
                { name = "dap" },
              },
            }
          )
        end,
      },
    },
  },
}

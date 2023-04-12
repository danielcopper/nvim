return {
    'mfussenegger/nvim-dap',
    config = function()
        vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

        -- adding language adapters
        local dap = require('dap')
        local nvim_data_path = vim.fn.expand("~") .. '\\AppData\\local\\nvim-data'

        dap.adapters.coreclr = {
            type = 'executable',
            command = nvim_data_path .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
            args = { '--interpreter=vscode' }
        }

        -- defining language specific configurations
        -- dotNET config:
        vim.g.dotnet_build_project = function()
            local default_path = vim.fn.getcwd() .. '/'
            if vim.g['dotnet_last_proj_path'] ~= nil then
                default_path = vim.g['dotnet_last_proj_path']
            end
            local path = vim.fn.input('Path to your *proj file: ', default_path, 'file')
            vim.g['dotnet_last_proj_path'] = path
            -- TODO: Test the rebuild functionality
            local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
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
                return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net6.0/', 'file')
            end

            if vim.g['dotnet_last_dll_path'] == nil then
                vim.g['dotnet_last_dll_path'] = request()
            else
                if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'],
                        '&yes\n&no', 2) == 1 then
                    vim.g['dotnet_last_dll_path'] = request()
                end
            end

            return vim.g['dotnet_last_dll_path']
        end

        local dotnet_config = {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                    vim.g.dotnet_build_project()
                end
                return vim.g.dotnet_get_dll_path()
            end,
        }

        -- assigning the dotnet configurations
        dap.configurations.cs = { dotnet_config, }
        dap.configurations.fsharp = { dotnet_config, }

        -- Typescript config
        -- TODO: Replace with VSCode JS Debugger once it is DAP compliant
        dap.adapters.chrome = {
            -- executable: launch the remote debug adapter - server: connect to an already running debug adapter
            type = "executable",
            -- command to launch the debug adapter - used only on executable type
            command = "node",
            args = {
                nvim_data_path .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js"
            }
        }

        -- The configuration must be named: typescript
        dap.configurations.typescript = {
            {
                name = "Debug (Attach) - Remote",
                type = "chrome",
                request = "attach",
                -- program = "${file}",
                -- cwd = vim.fn.getcwd(),
                sourceMaps = true,
                --      reAttach = true,
                trace = true,
                -- protocol = "inspector",
                -- hostName = "127.0.0.1",
                port = 9222,
                webRoot = "${workspaceFolder}"
            }
        }

        -- local function configureDap()
        --     local status_ok, dap = pcall(require, "dap")
        --     if not status_ok then
        --         print("The dap extension could not be loaded")
        --         return
        --     end
        --
        --     dap.set_log_level("DEBUG")
        --
        --     vim.highlight.create('DapBreakpoint', { ctermbg = 0, guifg = '#993939', guibg = '#31353f' }, false)
        --     vim.highlight.create('DapLogPoint', { ctermbg = 0, guifg = '#61afef', guibg = '#31353f' }, false)
        --     vim.highlight.create('DapStopped', { ctermbg = 0, guifg = '#98c379', guibg = '#31353f' }, false)
        --
        --     vim.fn.sign_define('DapBreakpoint', {
        --         text = '',
        --         texthl = 'DapBreakpoint',
        --         linehl = 'DapBreakpoint',
        --         numhl = 'DapBreakpoint'
        --     })
        --     vim.fn.sign_define('DapBreakpointCondition',
        --         { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
        --     vim.fn.sign_define('DapBreakpointRejected',
        --         { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
        --     vim.fn.sign_define('DapLogPoint',
        --         { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
        --     vim.fn.sign_define('DapStopped',
        --         { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
        --
        --     return dap
        -- end
        --
        -- local function configure()
        --     local dap = configureDap()
        --
        --     if nil == dap then
        --         print("The DAP core debugger could not be set")
        --     end
        --
        --     configureDebuggerAngular(dap)
        -- end
    end,
    keys = {
        vim.keymap.set('n', '<leader>b', ':DapToggleBreakpoint<CR>', { desc = 'Toggle Breakpoint' }),
        vim.keymap.set('n', '<F5>', ':DapContinue<CR>', { desc = 'Debug Continue' }),
        vim.keymap.set('n', '<S-F5>', ':DapTerminate<CR>', { desc = 'Stop Debugging' }),
        vim.keymap.set('n', '<F10>', ':DapStepOver<CR>', { desc = 'Debug Step Over' }),
        vim.keymap.set('n', '<F11>', ':DapStepInto<CR>', { desc = 'Debug Step Into' }),
        vim.keymap.set('n', '<S-F11>', ':DapStepOut<CR>', { desc = 'Debug Step Out' }),
        vim.keymap.set('n', '<leader>repl', ':DapToggleRepl<CR>', { desc = 'Untested...' }),
    }
}

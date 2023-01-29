return {
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        config = function()
            vim.keymap.set('n', '<leader>b', ':DapToggleBreakpoint<CR>')
            vim.keymap.set('n', '<F5>', ':DapContinue<CR>')
            vim.keymap.set('n', '<S-F5>', ':DapTerminate<CR>')
            vim.keymap.set('n', '<F10>', ':DapStepOver<CR>')
            vim.keymap.set('n', '<F11>', ':DapStepInto<CR>')
            vim.keymap.set('n', '<S-F11>', ':DapStepOut<CR>')
            vim.keymap.set('n', '<leader>repl', ':DapToggleRepl<CR>')

            -- adding language adapters
            local dap = require('dap')
            dap.adapters.coreclr = {
                type = 'executable',
                -- TODO: Figure out why accessing the home directory with ~/ doesnt work
                command = 'C:/Users/danie/AppData/Local/nvim-data/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
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

            -- assigning the configurations
            dap.configurations.cs = { dotnet_config, }
            dap.configurations.fsharp = { dotnet_config, }
        end
    }
}

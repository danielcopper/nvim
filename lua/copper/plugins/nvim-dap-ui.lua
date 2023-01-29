return {
    'rcarriga/nvim-dap-ui',
    config = function()
        require('dapui').setup()
        local dap, dapui = require("dap"), require("dapui")

        -- auto open and close ui on debug session
        dap.listeners.after.event_initialized["dapui_config"] = function()
            -- auto close file explorer
            vim.cmd "NvimTreeClose"
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            -- reopen file explorer
            vim.cmd "NvimTreeOpen"
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            -- reopen file explorer
            vim.cmd "NvimTreeOpen"
            dapui.close()
        end
    end
}

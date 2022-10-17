local M = {
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require('dap')
        dap.adapters.php = {
            type = "executable",
            command = "php-debug-adapter",
            port = 9003,
        }

        dap.configurations.php = {
            {
                type = 'php',
                request = 'launch',
                name = 'Listen for Xdebug',
                port = 9003,
                pathMapping = {
                    ['/var/www/backend'] = '${workspaceFolder}',
                },
            }
        }

        require("dapui").setup()

        vim.keymap.set('n', '<k5>', dap.continue)
        vim.keymap.set('n', '<k6>', dap.step_over)
        vim.keymap.set('n', '<k2>', dap.step_into)
        vim.keymap.set('n', '<k8>', dap.step_out)
        vim.keymap.set('n', ',b', dap.toggle_breakpoint)
        vim.keymap.set('n', ',B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
        vim.keymap.set('n', ',lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
        vim.keymap.set('n', ',dr', dap.repl.open)
        vim.keymap.set('n', ',dl', dap.run_last)
    end,
}

return M

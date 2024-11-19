local M = {
    'mfussenegger/nvim-dap',
    keys = {
        { '<k5>', function() require('dap').continue() end },
        { '<k6>', function() require('dap').step_over() end },
        { '<k2>', function() require('dap').step_into() end },
        { '<k8>', function() require('dap').step_out() end },
        { ',b',   function() require('dap').toggle_breakpoint() end },
        { ',B', function()
            require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end },
        { ',lp', function()
            require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end },
        { ',dr', function() require('dap').repl.open() end },
        { ',dl', function() require('dap').run_last() end },
    },
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
    end,
}

return M

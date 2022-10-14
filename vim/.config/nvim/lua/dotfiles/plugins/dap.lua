local M = {
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require('dap')
        dap.adapters.php = {
            type = 'server',
            port = 9993,
        }

        dap.configurations.php = {
            {
                type = 'php',
                request = 'launch',
                name = 'Listen for Xdebug',
                port = 9993,
                pathMapping = {
                    ['/var/www'] = '${workplaceFolder}',
                },
            }
        }
    end,
}

return M

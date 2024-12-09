local M = {
    'mfussenegger/nvim-dap',
    keys = {
        { ',f', function() require('dap').continue() end },
        { ',a', function() require('dap').step_back() end },
        { ',d', function() require('dap').step_over() end },
        { ',s', function() require('dap').step_into() end },
        { ',w', function() require('dap').step_out() end },
        { ',r', function() require('dap').run_last() end },
        { ',b', function() require('dap').toggle_breakpoint() end },
        { ',B', function()
            require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end },
        { ',l', function()
            require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end },
        { ',c', function() require('dap').repl.toggle() end },
        {
            ',x',
            function()
                require('dap').terminate()
                require('dapui').close()
            end,
            desc = "Shutdown DAPUI"
        },
    },
    config = function()
        local dap = require('dap')
        local dapui = require("dapui")
        -- dap.set_log_level('TRACE')

        -- auto open and close dapui
        dap.listeners.before.attach.dapui_config = function() dapui.open() end
        dap.listeners.before.launch.dapui_config = function() dapui.open() end
        dap.listeners.after.event_terminated.dapui_config = function() dapui.close() end
        dap.listeners.after.event_exited.dapui_config = function() dapui.close() end

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
                pathMappings = {
                    ['/var/www/backend'] = '${workspaceFolder}',
                },
            }
        }

        -- dap.adapters.python = {
        --     type = 'executable',
        --     command = os.getenv('HOME') .. '/.virtualenvs/tools/bin/python',
        --     args = { '-m', 'debugpy.adapter' },
        -- }

        dap.adapters.lldb = {
            type = "executable",
            command = "codelldb",
            name = "lldb",
        }
        -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-codelldb
        dap.configurations.rust = {
            {
                name = 'Launch',
                type = 'lldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
                initCommands = function()
                    -- Find out where to look for the pretty printer Python module
                    local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

                    local script_import = 'command script import "' ..
                        rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                    local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

                    local commands = {}
                    local file = io.open(commands_file, 'r')
                    if file then
                        for line in file:lines() do
                            table.insert(commands, line)
                        end
                        file:close()
                    end
                    table.insert(commands, 1, script_import)

                    return commands
                end,
            },
        }

        require("dapui").setup()
    end,
}

return M

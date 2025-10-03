local env = require("dotfiles.utils.env")

local M = {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap-python",
        "jbyuki/one-small-step-for-vimkind",
        "leoluz/nvim-dap-go",
    },
    keys = {
        {
            ",f",
            function()
                require("dap").continue()
            end,
        },
        {
            ",a",
            function()
                require("dap").step_back()
            end,
        },
        {
            ",d",
            function()
                require("dap").step_over()
            end,
        },
        {
            ",s",
            function()
                require("dap").step_into()
            end,
        },
        {
            ",w",
            function()
                require("dap").step_out()
            end,
        },
        {
            ",r",
            function()
                require("dap").run_last()
            end,
        },
        {
            ",b",
            function()
                require("dap").toggle_breakpoint()
            end,
        },
        {
            ",B",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
        },
        {
            ",c",
            function()
                require("dap").clear_breakpoints()
            end,
        },
        {
            ",l",
            function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end,
        },
        {
            ",x",
            function()
                require("dap").clear_breakpoints()
                require("dap").terminate()
                require("dapui").close()
            end,
            desc = "Shutdown DAPUI",
        },
        {
            ",D",
            function()
                require("osv").launch({ port = 8086 })
            end,
            desc = "Launch Lua debug server",
        },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        -- dap.set_log_level('TRACE')

        -- use debugpy from mason
        require("dap-python").setup(env.mason_bin("debugpy-adapter"))

        -- auto open and close dapui
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.after.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.after.event_exited.dapui_config = function()
            dapui.close()
        end

        require("dap-go").setup()

        dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }

        dap.adapters.php = {
            type = "executable",
            command = "php-debug-adapter",
            port = 9003,
        }
        dap.configurations.php = {
            {
                name = "Listen for Xdebug",
                type = "php",
                request = "launch",
                port = 9003,
            },
        }

        dap.configurations.python = {
            {
                name = "Attach to DebugPy",
                type = "python",
                request = "attach",
                port = 5678,
                jinja = true,
            },
        }

        dap.adapters.lldb = {
            type = "executable",
            command = "codelldb",
            name = "lldb",
        }
        -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-codelldb
        dap.configurations.rust = {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                initCommands = function()
                    -- Find out where to look for the pretty printer Python module
                    local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

                    local script_import = 'command script import "'
                        .. rustc_sysroot
                        .. '/lib/rustlib/etc/lldb_lookup.py"'
                    local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

                    local commands = {}
                    local file = io.open(commands_file, "r")
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

        require("dapui").setup({
            layouts = {
                {
                    elements = {
                        {
                            id = "watches",
                            size = 0.60,
                        },
                        {
                            id = "stacks",
                            size = 0.40,
                        },
                    },
                    position = "bottom",
                    size = 10,
                },
                {
                    elements = {
                        {
                            id = "repl",
                            size = 0,
                        },
                        {
                            id = "breakpoints",
                            size = 0.30,
                        },
                        {
                            id = "scopes",
                            size = 0.70,
                        },
                    },
                    position = "left",
                    size = 50,
                },
            },
        })
    end,
}

return M

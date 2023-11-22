local M = {}

M.save_copy_prompt = 'Save copy as:'

local function noop_if_empty(callback)
    return function(input)
        if input == nil then return end
        callback(input)
    end
end

local function show_save_copy_prompt()
    vim.keymap.set(
        'n',
        '<leader>ws',
        function()
            vim.ui.input(
                { prompt = M.save_copy_prompt },
                noop_if_empty(function(input)
                    vim.cmd.WriteSibling(input)
                end)
            )
        end
    )
end

local function manager_keybinds()
    vim.keymap.set('n', "<leader>l", require("lazy").home)
    vim.keymap.set('n', "<leader>m", require("mason.ui").open)
end

function M.setup()
    show_save_copy_prompt()
    manager_keybinds()
end

return M

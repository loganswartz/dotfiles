local M = {}

M.save_copy_prompt = 'Save copy as:'

function M.noop_if_empty(callback)
    return function(input)
        if input == nil then return end
        callback(input)
    end
end

function M.show_save_copy_prompt()
    vim.keymap.set(
        'n',
        '<leader>ws',
        function()
            vim.ui.input(
                { prompt = M.save_copy_prompt },
                M.noop_if_empty(function(input)
                    vim.cmd.WriteSibling(input)
                end)
            )
        end
    )
end

function M.setup()
    M.show_save_copy_prompt()
end

return M

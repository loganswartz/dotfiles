local M = {}

function M.wrap_on_choice(callback)
    return function(input)
        if input == nil then return end
        callback(input)
    end
end

function M.show_write_sibling_prompt()
    vim.keymap.set(
        'n',
        '<leader>ws',
        function() vim.ui.input(
            { prompt = 'Write Sibling File' },
            M.wrap_on_choice(function(input) vim.cmd.WriteSibling(input) end)
        ) end
    )
end

function M.setup()
    M.show_write_sibling_prompt()
end

return M

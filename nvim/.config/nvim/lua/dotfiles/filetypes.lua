local M = {}

function M.setup()
    vim.filetype.add({
        filename = {
            ['.env'] = 'config',
        },
        pattern = {
            ['%.env%.[%w_.-]+'] = 'config',
        },
    })
end

return M

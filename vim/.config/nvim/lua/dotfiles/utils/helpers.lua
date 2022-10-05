local M = {}

function M.cmd_factory(cmd)
    return function()
        vim.cmd(cmd)
    end
end

function M.auto_open_diag_hover()
    local function is_float_window(id)
        return vim.api.nvim_win_get_config(id).relative ~= ''
    end

    local float_is_open = vim.tbl_count(vim.tbl_filter(is_float_window, vim.api.nvim_list_wins())) > 0
    if not float_is_open then
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end
end

function M.openLink(link)
    local Job = require('plenary.job')
    Job:new({ command = 'xdg-open', args = { link } }):start()
end

function M.iteratorToArray(...)
    local arr = {}
    for v in ... do
        arr[#arr + 1] = v
    end
    return arr
end

function M.make_hover_callback(callback)
    return function(error, result, ctx, config)
        local value = result.contents[2]

        return callback(value)
    end
end

return M

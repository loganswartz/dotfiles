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
        vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
    end
end

return M

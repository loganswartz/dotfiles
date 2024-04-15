local M = {}

function M.get_sql_statement_under_cursor()
    local tree = vim.treesitter.get_parser(0, 'sql'):parse()

    local query = vim.treesitter.query.parse('sql', [[
      (statement) @statement
    ]])

    local pos = vim.api.nvim_win_get_cursor(0)

    for _, capture, _ in query:iter_captures(tree[1]:root(), 1, pos[1] - 1, pos[1]) do
        return capture
    end
end

function M.execute_query_under_cursor()
    local ts_utils = require('nvim-treesitter.ts_utils')

    -- attempt to find a statement node under the cursor
    local node = M.get_sql_statement_under_cursor()
    if node then
        ts_utils.update_selection(0, node)
    else
        -- if no statement node is found, select the current paragraph
        vim.cmd.normal [[ vip ]]
    end

    vim.api.nvim_input [[ <Plug>(DBUI_ExecuteQuery) ]]
end

return M

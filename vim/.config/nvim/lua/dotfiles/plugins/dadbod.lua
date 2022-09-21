local M = {
    'tpope/vim-dadbod',
    config = function()
        -- za or return to open drawer option (same as folds)
        local function remapDbuiToggle(combo)
            return function()
                vim.keymap.set('n', combo, '<Plug>(DBUI_SelectLine)', { buffer = true })
            end
        end

        vim.api.nvim_create_autocmd({ 'FileType' }, {
            pattern = 'dbui',
            callback = remapDbuiToggle('za'),
        })
        vim.api.nvim_create_autocmd({ 'FileType' }, {
            pattern = 'dbui',
            callback = remapDbuiToggle('<CR>'),
        })
        vim.fn['db_ui#utils#set_mapping']('<C-E>', '<Plug>(DBUI_ExecuteQuery)')

        -- run a single query instead of the whole file (analogous to dbeaver's Ctrl+Enter)
        -- vim.keymap.set('n', '<C-E>', 'vip\S')
    end,
}

return M
